#
# Cookbook Name:: rubygems-monitoring
# Recipe:: default
#

include_recipe 'chef-vault'

dnsimple_credentials = chef_vault_item('dnsimple', 'credentials')

include_recipe 'dnsimple'

dnsimple_record "create CNAME point monitoring.rubygems.org to #{node.name}" do
  name     'monitoring.rubygems.org'
  content  node['fqdn']
  type     'CNAME'
  domain   'rubygems.org'
  domain_api_token dnsimple_credentials['api_token']
  action   :create
end

include_recipe 'rubygems-sensu::server'
include_recipe 'rubygems'
include_recipe 'rubygems-monitoring::nginx'
