#
# Cookbook Name:: rubygems-balancer
# Recipe:: default
#

node.default['nginx']['server_tokens'] = 'off'
node.default['nginx']['default_site_enabled'] = false
node.default['nginx']['package_name'] = 'nginx-extras'

include_recipe 'nginx'

include_recipe 'rubygems-balancer::ssl'
include_recipe 'rubygems-balancer::geoip'
include_recipe 'rubygems-balancer::maintenance'
include_recipe 'rubygems-balancer::site'
