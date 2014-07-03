#
# Cookbook Name:: rubygems-hostname
# Recipe:: dns
#

include_recipe 'chef-vault'

dnsimple_credentials = chef_vault_item('dnsimple', 'credentials')

include_recipe 'dwradcliffe-dnsimple'

if node['cloud_v2']
  dwradcliffe_dnsimple_record "create a CNAME record for #{node.name}" do
    name     node.name.sub('.rubygems.org', '')
    content  node['cloud_v2']['public_hostname']
    type     'CNAME'
    domain   'rubygems.org'
    username dnsimple_credentials['username']
    password dnsimple_credentials['password']
    action   :create
  end
else
  dwradcliffe_dnsimple_record "create A record for #{node.name}" do
    name      node.name.sub('.rubygems.org', '')
    content   `/usr/bin/curl http://169.254.169.254/latest/meta-data/public-ipv4`.chomp
    type      'A'
    domain    'rubygems.org'
    username  dnsimple_credentials['username']
    password  dnsimple_credentials['password']
    action    :create
  end
end
