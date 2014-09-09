#
# Cookbook Name:: rubygems-chef-server
# Recipe:: default
#

node.default['chef-server']['api_fqdn'] = 'chef.rubygems.org'
node.default['chef-server']['configuration']['nginx']['ssl_certificate'] = '/etc/chef-server/rubygems.crt'
node.default['chef-server']['configuration']['nginx']['ssl_certificate_key'] = '/etc/chef-server/rubygems.key'

include_recipe 'chef-vault'

item = chef_vault_item('certs', 'production')

directory '/etc/chef-server'

file '/etc/chef-server/rubygems.org.key' do
  content item['key']
  owner  'root'
  group  'root'
  mode   '0644'
end

file '/etc/chef-server/rubygems.org.crt' do
  content item['crt']
  owner  'root'
  group  'root'
  mode   '0644'
end

include_recipe 'chef-server'
