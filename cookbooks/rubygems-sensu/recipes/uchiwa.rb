#
# Cookbook Name: rubygems-sensu
# Recipe:: uchiwa
#

include_recipe 'chef-vault'

node.default['uchiwa']['version'] = '0.20.2-1'
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
  team 'monitoring'
  upstream_port 3000
  server_name 'monitoring.rubygems.org'
  client_id auth_bag['client_id']
  client_secret auth_bag['client_secret']
  cookie_secret auth_bag['cookie_secret']
end

dnsimple_credentials = chef_vault_item('dnsimple', 'credentials')
aws_credentials = chef_vault_item('aws', 'credentials')

include_recipe 'dns'

dns_record "create CNAME point monitoring.rubygems.org to #{node.name}" do
  name 'monitoring'
  value node['fqdn']
  type 'CNAME'
  domain 'rubygems.org'
  zone_id 'Z3ME4ZZV9EACZN'
  credentials(
    dnsimple: { domain_api_token: dnsimple_credentials['api_token'] },
    route53: { aws_access_key_id: aws_credentials['access_key_id'], aws_secret_access_key: aws_credentials['secret_access_key'] }
  )
end
