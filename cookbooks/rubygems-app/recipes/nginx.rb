#
# Cookbook Name:: rubygems-app
# Recipe:: nginx
#

node.default['nginx']['server_tokens'] = 'off'
node.default['nginx']['default_site_enabled'] = false
node.default['nginx']['package_name'] = 'nginx-extras'

include_recipe 'nginx'

lb_ip = search(:node, "roles:balancer AND chef_environment:#{node.chef_environment}")[0]['ipaddress']

template "#{node['nginx']['dir']}/sites-available/rubygems" do
  source 'nginx.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  variables(
    rails_env:  node.chef_environment,
    rails_root: '/applications/rubygems',
    load_balancer_ip: lb_ip,
    unicorn_port: 3000,
    nginx_port: 9000
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'rubygems'

node.default['datadog']['nginx']['instances'] = [{ 'nginx_status_url' => 'http://localhost/nginx_status/' }]
include_recipe 'datadog::nginx'
