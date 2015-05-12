#
# Cookbook Name:: rubygems-logging
# Recipe:: server_nginx
#

node.default['nginx']['server_tokens'] = 'off'
node.default['nginx']['default_site_enabled'] = false

include_recipe 'nginx'

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

auth_bag = chef_vault_item('apps', 'kibana')

file "#{node['nginx']['dir']}/htpasswd" do
  owner 'root'
  group 'root'
  mode '0644'
  content "#{auth_bag['user']}:#{auth_bag['htpasswd']}"
end

template "#{node['nginx']['dir']}/sites-available/kibana" do
  source 'nginx.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

nginx_site 'kibana'
