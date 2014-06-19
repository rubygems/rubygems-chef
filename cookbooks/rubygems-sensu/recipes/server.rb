#
# Cookbook Name:: rubygems-sensu
# Recipe:: server
#

include_recipe 'chef-vault'

sensu_creds = chef_vault_item('sensu', 'credentials')

node.default['sensu']['use_ssl'] = false
node.default['sensu']['dashboard']['bind'] = '0.0.0.0'
node.default['sensu']['dashboard']['user'] = sensu_creds['user']
node.default['sensu']['dashboard']['password'] = sensu_creds['password']

sensu_handler 'default' do
  type 'pipe'
  command 'cat'
end

include_recipe 'rubygems-sensu::librato'
include_recipe 'rubygems-sensu::slack'

include_recipe 'sensu::rabbitmq'

apt_preference "rabbitmq-server" do
  pin "version 3.1.5"
  pin_priority "700"
end

include_recipe 'sensu::redis'
include_recipe 'sensu::server_service'
include_recipe 'sensu::api_service'
include_recipe 'sensu::dashboard_service'
