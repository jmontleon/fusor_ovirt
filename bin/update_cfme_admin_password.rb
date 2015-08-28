#!/usr/bin/env ruby

miq_environment = "/var/www/miq/vmdb/config/environment"
require miq_environment

user_name = "admin"

admin_user = User.find_by_userid(user_name)
if not admin_user
  puts "Unable to find user: #{user_name}"
  exit 1
end
admin_user.change_password('smartvm', ARGV[0])

