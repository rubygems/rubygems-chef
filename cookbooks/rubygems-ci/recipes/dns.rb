include_recipe 'chef-vault'

dnsimple_credentials = chef_vault_item('dnsimple', 'credentials')

include_recipe 'dwradcliffe-dnsimple'

dwradcliffe_dnsimple_record "create CNAME point ci.rubygems.org to #{node.name}" do
  name     'ci.rubygems.org'
  content  node['cloud_v2']['public_hostname']
  type     'CNAME'
  domain   'rubygems.org'
  username dnsimple_credentials['username']
  password dnsimple_credentials['password']
  action   :create
end
