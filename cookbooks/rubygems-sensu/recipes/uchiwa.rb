#
# Cookbook Name: rubygems-sensu
# Recipe:: uchiwa
#

include_recipe 'rubygems'

include_recipe 'chef-vault'

sensu_creds = chef_vault_item('sensu', 'credentials')

node.default['uchiwa']['version'] = '0.6.0-1'
node.default['uchiwa']['settings']['user'] = sensu_creds['user']
node.default['uchiwa']['settings']['pass'] = sensu_creds['password']

apt_preference 'uchiwa' do
  pin "version #{node['uchiwa']['version']}"
  pin_priority '700'
end

include_recipe 'uchiwa'

include_recipe 'rubygems-sensu::uchiwa_nginx'

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
