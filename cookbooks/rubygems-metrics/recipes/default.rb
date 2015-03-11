#
# Cookbook Name:: rubygems-metrics
# Recipe:: default
#

include_recipe 'chef-vault'

package 'collectd' do
  action :remove
end

%w(
  /etc/collectd
  /usr/lib/collectd
  /opt/src/collectd-librato-0.0.10
  /var/lib/collectd
).each do |dir|
  directory dir do
    action :delete
    recursive true
  end
end

datadog_creds = chef_vault_item('datadog', 'credentials')

node.default['datadog']['api_key'] = datadog_creds['api_key']
node.default['datadog']['application_key'] = datadog_creds['application_key']

include_recipe 'datadog::dd-agent'
include_recipe 'datadog::dd-handler'
