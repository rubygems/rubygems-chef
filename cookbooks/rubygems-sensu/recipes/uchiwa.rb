#
# Cookbook Name: rubygems-sensu
# Recipe:: uchiwa
#

include_recipe 'chef-vault'

sensu_creds = chef_vault_item('sensu', 'credentials')

node.default['uchiwa']['version'] = '0.6.0-1'
node.default['uchiwa']['settings']['user'] = sensu_creds['user']
node.default['uchiwa']['settings']['pass'] = sensu_creds['password']

apt_preference 'uchiwa' do
  pin "version #{node['uchiwa']['version']}"
  pin_priority '700'
end

include_recipe 'uchiwa'
