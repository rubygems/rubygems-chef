node.default['set_fqdn'] = node['name']

include_recipe 'hostname'
