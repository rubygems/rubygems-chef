#
# Cookbook Name:: rubygems-database
# Recipe:: default
#

include_recipe 'rubygems-base'
include_recipe 'chef-vault'

secrets = chef_vault_item('rubygems', node.chef_environment)
app_host = data_bag_item('hosts', 'application')['environments'][node.chef_environment]

node.default['postgresql']['version'] = '9.3'
node.default['postgresql']['config']['listen_addresses'] = '0.0.0.0'
node.default['postgresql']['config']['work_mem'] = '100MB'
node.default['postgresql']['config']['shared_buffers'] = '24MB'
node.default['postgresql']['config']['checkpoint_segments'] = 16

apt_preference 'postgresql-9.3' do
  pin 'version 9.3.10-0ubuntu0.14.04'
  pin_priority '700'
end

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
    'type' => 'host',
    'db' => "rubygems_#{node.chef_environment}",
    'user' => 'datadog',
    'addr' => 'samehost',
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

package 'postgresql-contrib' # for hstore

include_recipe 'rubygems-backups::postgresql'

datadog_postgres_creds = chef_vault_item('postgresql', 'datadog')

node.default['datadog']['postgres']['instances'] = [
  {
    'server' => 'localhost',
    'username' => datadog_postgres_creds['username'],
    'password' => datadog_postgres_creds['password'],
    'dbname' => "rubygems_#{node.chef_environment}",
    'tags' => [node.chef_environment]
  }
]

include_recipe 'datadog::postgres'

cookbook_file '/etc/dd-agent/checks.d/delayed_job.py' do
  source 'delayed_job_check.py'
end

datadog_monitor 'delayed_job' do
  instances node['datadog']['postgres']['instances']
  cookbook 'rubygems-database'
end
