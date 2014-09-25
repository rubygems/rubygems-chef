#
# Cookbook Name:: rubygems-chef
# Recipe:: default
#

include_recipe 'rubygems-chef::librato'
include_recipe 'rubygems-chef::slack'

node.default['chef_client']['config']['ssl_verify_mode'] = ':verify_peer'
node.default['chef_client']['config']['client_fork'] = true

node.default['chef_client']['cron']['minute'] = '*/15'
node.default['chef_client']['cron']['hour'] = '*'

include_recipe 'chef-client::config'
include_recipe 'chef-client::cron'

service 'chef-client' do
  action [:stop, :disable]
end

node.default['omnibus_updater']['version'] = '11.16.2'
node.default['omnibus_updater']['restart_chef_service'] = true
include_recipe 'omnibus_updater'
