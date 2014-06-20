#
# Cookbook Name:: rubygems-chef
# Recipe:: default
#

cron 'chef-client' do
  action :delete
end

node.default['chef_client']['config']['ssl_verify_mode'] = ':verify_peer'
node.default['chef_client']['config']['client_fork'] = true

include_recipe 'chef-client::config'
include_recipe 'chef-client'
