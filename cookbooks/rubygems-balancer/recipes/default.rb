#
# Cookbook Name:: rubygems-balancer
# Recipe:: default
#

include_recipe 'rubygems-base'

node.default['nginx']['server_tokens'] = 'off'
node.default['nginx']['default_site_enabled'] = false
node.default['nginx']['repo_source'] = 'nginx'
node.default['nginx']['worker_rlimit_nofile'] = 10240

include_recipe 'chef-vault'

include_recipe 'rubygems-balancer::mounts'

include_recipe 'chef_nginx'

include_recipe 'rubygems-people::deploy'
include_recipe 'rubygems-balancer::logging'
include_recipe 'rubygems-balancer::ssl'
include_recipe 'rubygems-balancer::maintenance'
include_recipe 'rubygems-balancer::site'
include_recipe 'rubygems-balancer::logrotate'

cookbook_file '/etc/default/nginx' do
  source 'nginx'
  notifies :reload, 'service[nginx]'
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
end

node.default['datadog']['nginx']['instances'] = [{ 'nginx_status_url' => 'http://localhost/nginx_status/' }]
include_recipe 'datadog::nginx'
