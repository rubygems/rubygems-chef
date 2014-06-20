#
# Cookbook Name:: rubygems-database
# Recipe:: default
#

include_recipe 'rubygems'

node.default['postgresql']['data_directory'] = '/var/lib/pg_data'
node.default['postgresql']['listen_addresses'] = '0.0.0.0'
node.default['postgresql']['ssl'] = false
node.default['postgresql']['work_mem'] = '100MB'
node.default['postgresql']['shared_buffers'] = '24MB'
node.default['postgresql']['users'] = [{
  'username' => 'postgres',
  'password' => 'postgres',
  'superuser' => true,
  'createdb' => true,
  'login' => true
}]
node.default['postgresql']['pg_hba'] = [
  {
    'type' => 'host',
    'db' => "rubygems_#{node.chef_environment}",
    'user' => 'postgres',
    'password' => 'postgres',
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

stage = node.chef_environment

connection_info =  {
  host: '127.0.0.1',
  port: 5432,
  username: 'postgres'
}

postgresql_database_user "rubygems_#{stage}" do
  connection(connection_info)
  password ''
  action :create
end

connection_info['username'] = "rubygems_#{stage}"

postgresql_database "rubygems_#{stage}" do
  connection(connection_info)
  action :create
end
