#
# Cookbook Name:: rubygems-stat-update
# Recipe:: default
#

include_recipe 'runit'

user 'stat-update' do
  shell '/bin/false'
  home '/var/run/stat-update'
  system true
end

# TODO: intall package

redis_host = data_bag_item('hosts', 'redis')['environments'][node.chef_environment]
redis_ip = search('node', "name:#{redis_host}.#{node.chef_environment}.rubygems.org")[0]['ipaddress']

runit_service 'stat-update' do
  owner 'stat-update'
  group 'stat-update'
  default_logger true
  options(redis_host: redis_ip)
end
