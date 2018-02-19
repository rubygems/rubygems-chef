#
# Cookbook Name:: rubygems-chef-server
# Recipe:: default
#

node.default['chef-server']['api_fqdn'] = 'chef.rubygems.org'
node.default['chef-server']['version'] = '12.6.0'
node.default['chef-server']['addons'] = ['reporting']
node.default['chef-server']['accept_license'] = true

node.default['chef-server']['configuration'] = <<-EOS
nginx['ssl_certificate'] = '/etc/chef-server/rubygems.crt'
nginx['ssl_certificate_key'] = '/etc/chef-server/rubygems.key'
nginx['ssl_protocols'] = 'TLSv1.2'
nginx['ssl_ciphers'] = 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256'
EOS

include_recipe 'chef-vault'

item = chef_vault_item('certs', 'production')

directory '/etc/chef-server'

file '/etc/chef-server/rubygems.key' do
  content item['key']
  owner  'root'
  group  'root'
  mode   '0644'
end

file '/etc/chef-server/rubygems.crt' do
  content item['crt']
  owner  'root'
  group  'root'
  mode   '0644'
end

include_recipe 'chef-server'
include_recipe 'chef-server::addons'
