#
# Cookbook Name:: rubygems-chef
# Recipe:: librato
#

include_recipe 'chef-vault'
librato_creds = chef_vault_item('librato', 'credentials')

directory '/etc/chef/client.d'

chef_gem 'librato-metrics' do
  version '1.4.0'
end

chef_gem 'chef-handler-librato' do
  version '1.1.6'
end

template '/etc/chef/client.d/librato.rb' do
  source 'librato.rb'
  mode '0644'
  variables(
    email: librato_creds['email'],
    api_key: librato_creds['token']
  )
end
