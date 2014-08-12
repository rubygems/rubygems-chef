#
# Cookbook Name:: rubygems-database
# Recipe:: default
#

include_recipe 'rubygems'
include_recipe 'chef-vault'

secrets = chef_vault_item('rubygems', node.chef_environment)
app_host = data_bag_item('hosts', 'application')['environments'][node.chef_environment]

node.default['postgresql']['config']['listen_addresses'] = '0.0.0.0'
node.default['postgresql']['config']['work_mem'] = '100MB'
node.default['postgresql']['config']['shared_buffers'] = '24MB'

# TODO: this needs to iterate over a list of application servers in the data
# bag.
node.default['postgresql']['pg_hba'] = [
  {
    'type' => 'host',
    'db' => "rubygems_#{node.chef_environment}",
    'user' => secrets['rails_postgresql_user'],
    'addr' => "#{search('node', "name:#{app_host}.#{node.chef_environment}.rubygems.org")[0]['ipaddress']}/0",
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

include_recipe 'rubygems-backups::postgresql'

include_recipe 'rubygems-metrics::postgresql'
