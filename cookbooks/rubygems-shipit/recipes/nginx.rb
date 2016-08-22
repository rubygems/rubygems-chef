#
# Cookbook Name:: rubygems-shipit
# Recipe:: nginx
#

node.default['nginx']['server_tokens'] = 'off'
node.default['nginx']['default_site_enabled'] = false
node.default['nginx']['repo_source'] = 'nginx'

include_recipe 'chef_nginx'

directory "#{node['nginx']['dir']}/certs" do
  owner 'root'
  group 'root'
  mode  '0644'
end

item = chef_vault_item('certs', 'production')

file "#{node['nginx']['dir']}/certs/rubygems.org.key" do
  content item['key']
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

file "#{node['nginx']['dir']}/certs/rubygems.org.crt" do
  content item['crt']
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

template "#{node['nginx']['dir']}/sites-available/shipit" do
  source 'nginx.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

nginx_site 'shipit'
