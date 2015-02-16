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

# See: https://github.com/opscode-cookbooks/chef-client/issues/196
if node.name == 'chef.common.rubygems.org'
  r = resources(template: '/etc/chef/client.rb')
  r.user 'root'
  r.group 'root'
end

include_recipe 'chef-client::cron'

service 'chef-client' do
  action [:stop, :disable]
end

node.default['omnibus_updater']['version'] = '12.0.3'
node.default['omnibus_updater']['restart_chef_service'] = true
include_recipe 'omnibus_updater'
