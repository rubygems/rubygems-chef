#
# Cookbook Name:: rubygems-app
# Recipe:: dirs
#

['/applications/rubygems', '/applications/rubygems/releases', '/applications/rubygems/shared', '/applications/rubygems/shared/config', '/applications/rubygems/shared/log'].each do |dir|
  directory dir do
    owner  'deploy'
    group  'deploy'
    mode   '0775'
  end
end
