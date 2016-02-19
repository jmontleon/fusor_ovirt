#!/usr/bin/env ruby

miq_environment = "/var/www/miq/vmdb/config/environment"
require miq_environment
require 'csv'

ERROR_FILE_NOT_EXIST = 1
ERROR_CSV_HOST_NUM   = 2
ERROR_PROVIDER       = 3
ERROR_HOST_NOT_FOUND = 4
ERROR_HOST_DETAIL    = 5

CHECK_SLEEP = 30 
MAX_RETRY   = 6

if !ARGV[0]
  provider_name = "rhev_deployment"
else
  provider_name = ARGV[0]
end

if !ARGV[1]
  user_name = "root"
else
  user_name = ARGV[1]
end

if !ARGV[2]
  password = "changeme"
else
  password = ARGV[2]
end

if !ARGV[3]
  csv_fname = "hosts.csv"
else
  csv_fname = ARGV[3]
end

if !File.exist?(csv_fname)
  puts "ERROR - the host csv file \"#{csv_fname}\" does not exist!"
  exit ERROR_FILE_NOT_EXIST
end

# open csv and get number of hosts in csv
csv_hosts = CSV.parse(File.read(csv_fname), :headers => true)
num_csv_hosts = CSV.readlines(csv_fname, skip_blanks: true, headers: true).size
if num_csv_hosts.nil? || num_csv_hosts == 0
  puts "ERROR - number of hosts from \"#{csv_fname}\" is ZERO or NIL"
  exit ERROR_CSV_HOST_NUM
end

# get the provider
rhev_provider = ManageIQ::Providers::Redhat::InfraManager.find_by_name(provider_name)
if !rhev_provider
  puts "ERROR - provider is nil!"
  exit ERROR_PROVIDER
end

# get the host list & check against the csv provided
# (due to the delay in host availability, wait and recheck)
tries = MAX_RETRY
while tries > 0 do
  rhev_hosts = rhev_provider.hosts
  if !rhev_hosts
    puts "hosts is nil! recheck in #{CHECK_SLEEP} seconds... "
    sleep(CHECK_SLEEP)
  elsif rhev_hosts.count != num_csv_hosts
    puts "number of host is not equal to ! recheck in #{CHECK_SLEEP} seconds..."
    sleep(CHECK_SLEEP)
  else
    break
  end
  tries -= 1
end

# verify the ip & hostname against the csv host list
rhev_hosts.each do |rhost|
  match = csv_hosts.find{|row| row['ip'] == rhost.ipaddress}
  if match == ""
    puts "ERROR - Host with #{rhost.ipaddress}, #{rhost.hostname} was NOT FOUND!"
    exit ERROR_HOST_NOT_FOUND
  elsif !match[1].strip.eql?(rhost.hostname.strip)
    puts "ERROR - IP and Hostname does NOT match for IP=\"#{rhost.ipaddress}\"! "
    puts "  hostname is \"#{rhost.hostname}\", expected \"#{match[1]}\""
    exit ERROR_HOST_DETAIL
  end
end

# add credentials to the hosts
creds = {}
creds[:default] = {:userid => user_name, :password => password}

rhev_hosts.each do |rhost|
  rhost.update_authentication(creds)
end

puts "Success - added credentials to the hosts!"
