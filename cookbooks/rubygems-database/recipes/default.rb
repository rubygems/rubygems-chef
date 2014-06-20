#
# Cookbook Name:: rubygems-database
# Recipe:: default
#

include_recipe 'rubygems'
include_recipe 'chef-vault'

secrets = chef_vault_item('rubygems', node.chef_environment)

node.default['postgresql']['config']['listen_addresses'] = '0.0.0.0'
node.default['postgresql']['config']['work_mem'] = '100MB'
node.default['postgresql']['config']['shared_buffers'] = '24MB'

node.default['postgresql']['pg_hba'] = [
  {
    'type' => 'host',
    'db' => "rubygems_#{node.chef_environment}",
    'user' => secrets['rails_postgresql_user'],
    'password' => secrets['rails_postgresql_password'],
    'addr' => "#{search(:node, "name:app01.#{node.chef_environment}.rubygems.org")[0]['ipaddress']}/0",
    'method' => 'md5'
  },
  {
    'type' => 'local',
    'db' => 'all',
    'user' => 'postgres',
    'method' => 'ident'
  }
]

include_recipe 'postgresql::server'
include_recipe 'postgresql::ruby'
