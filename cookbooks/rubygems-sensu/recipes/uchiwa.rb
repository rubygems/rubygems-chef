#
# Cookbook Name: rubygems-sensu
# Recipe:: uchiwa
#

include_recipe 'rubygems'

include_recipe 'chef-vault'

node.default['uchiwa']['version'] = '0.6.0-1'
node.default['uchiwa']['settings']['user'] = ''
node.default['uchiwa']['settings']['pass'] = ''

apt_preference 'uchiwa' do
  pin "version #{node['uchiwa']['version']}"
  pin_priority '700'
end

include_recipe 'uchiwa'

auth_bag = chef_vault_item('apps', 'sensu')

auth_proxy 'sensu' do
  org 'rubygems'
  team 'infrastructure'
  upstream_port 3000
  server_name 'monitoring.rubygems.org'
  client_id auth_bag['client_id']
  client_secret auth_bag['client_secret']
  cookie_secret auth_bag['cookie_secret']
end

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
