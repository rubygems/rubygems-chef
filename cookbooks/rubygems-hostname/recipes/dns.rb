#
# Cookbook Name:: rubygems-hostname
# Recipe:: dns
#

include_recipe 'chef-vault'

dnsimple_credentials = chef_vault_item('dnsimple', 'credentials')

include_recipe 'dnsimple'

if node['cloud_v2']
  dnsimple_record "create a CNAME record for #{node.name}" do
    name     node.name.sub('.rubygems.org', '')
    content  node['cloud_v2']['public_hostname']
    type     'CNAME'
    domain   'rubygems.org'
    domain_api_token dnsimple_credentials['api_token']
    action   :create
  end
else
  dnsimple_record "create A record for #{node.name}" do
    name      node.name.sub('.rubygems.org', '')
    content   Mixlib::ShellOut.new('/usr/bin/curl http://169.254.169.254/latest/meta-data/public-ipv4').run_command.stdout.chomp
    type      'A'
    domain    'rubygems.org'
    domain_api_token  dnsimple_credentials['api_token']
    action    :create
  end
end
