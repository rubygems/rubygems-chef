#
# Cookbook Name:: rubygems-repo
# Recipe:: nginx
#

node.default['nginx']['server_tokens'] = 'off'
node.default['nginx']['default_site_enabled'] = false

include_recipe 'nginx'

template "#{node['nginx']['dir']}/sites-available/aptly" do
  source 'nginx.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

nginx_site 'aptly'
