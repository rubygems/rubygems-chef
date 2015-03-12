#
# Cookbook Name:: rubygems-metrics
# Recipe:: postgresql
#

include_recipe 'chef-vault'

dbhostname = data_bag_item('hosts', 'database')['environments'][node.chef_environment]
db_host = search(:node, "name:#{dbhostname}.#{node.chef_environment}.rubygems.org")[0]
credentials = chef_vault_item('postgresql', 'datadog')

file '/etc/collectd/plugins/postgresql.conf' do
  action :delete
end

node.default['datadog']['postgres']['instances'] = [
  {
    'server' => 'localhost',
    'username' => credentials['username'],
    'password' => credentials['password'],
    'tags' => [node.chef_environment]
  }
]

include_recipe 'datadog::postgres'
