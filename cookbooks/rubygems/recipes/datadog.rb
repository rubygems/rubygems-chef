#
# Cookbook Name:: rubygems
# Recipe:: datadog
#

execute 'pkill-collectd' do
  command '/usr/bin/pkill -9 collectd'
  only_if { ::File.exist?('/usr/sbin/collectd') }
end

package 'collectd-core' do
  action :remove
end

include_recipe 'chef-vault'

datadog_creds = chef_vault_item('datadog', 'credentials')

node.default['datadog']['api_key'] = datadog_creds['api_key']
node.default['datadog']['application_key'] = datadog_creds['application_key']

include_recipe 'datadog::dd-agent'
include_recipe 'datadog::dd-handler'
