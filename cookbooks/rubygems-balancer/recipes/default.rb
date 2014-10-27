#
# Cookbook Name:: rubygems-balancer
# Recipe:: default
#

include_recipe 'rubygems'

node.default['nginx']['server_tokens'] = 'off'
node.default['nginx']['default_site_enabled'] = false
node.default['nginx']['package_name'] = 'nginx-extras'

include_recipe 'chef-vault'

include_recipe 'nginx'

include_recipe 'rubygems-balancer::ssl'
include_recipe 'rubygems-balancer::geoip'
include_recipe 'rubygems-balancer::maintenance'
include_recipe 'rubygems-balancer::site'
include_recipe 'rubygems-balancer::logrotate'

cookbook_file '/etc/default/nginx' do
  source 'nginx'
  notifies :reload, 'service[nginx]'
end
