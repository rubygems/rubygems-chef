#
# Cookbook Name: rubygems-sensu
# Recipe:: uchiwa
#

node.default['uchiwa']['version'] = '0.6.0-1'
node.default['uchiwa']['settings']['user'] = ''
node.default['uchiwa']['settings']['pass'] = ''

apt_preference 'uchiwa' do
  pin "version #{node['uchiwa']['version']}"
  pin_priority '700'
end

include_recipe 'uchiwa'
