#
# Cookbook Name:: rubygems-hostname
# Recipe:: dns
#

include_recipe 'chef-vault'

dnsimple_credentials = chef_vault_item('dnsimple', 'credentials')

dnsimple_record "create a CNAME record for #{node.name}" do
  name     node.name.sub('.rubygems.org', '')
  content  node['cloud_v2']['public_hostname']
  type     'CNAME'
  domain   'rubygems.org'
  username dnsimple_credentials['username']
  password dnsimple_credentials['password']
  action   :create
end
