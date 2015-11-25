#!/usr/bin/env ruby

miq_environment = "/var/www/miq/vmdb/config/environment"
require miq_environment

if not ARGV[0]
  provider_name = "rhev_deployment"
else
  provider_name = ARGV[0]
end

if not ARGV[1]
  user_name = "root"
else
  user_name = ARGV[1]
end

if not ARGV[2]
  password = "changeme"
else
  password = ARGV[2]
end

rhev_provider = ManageIQ::Providers::Redhat::InfraManager.find_by_name(provider_name)
if not rhev_provider
  puts "provider is nil!"
  exit 1
end

rhev_hosts = rhev_provider.hosts
if not rhev_hosts
  puts "hosts is nil!"
  exit 1
end

creds = {}
creds[:default] = {:userid => user_name, :password => password}

rhev_hosts.each do |rhev_hosts|
  rhev_hosts.update_authentication(creds)
end

