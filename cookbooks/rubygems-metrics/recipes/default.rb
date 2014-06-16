librato_creds = ChefVault::Item.load('librato', 'credentials')

node.default['collectd_librato']['email'] = librato_creds['email']
node.default['collectd_librato']['api_token'] = librato_creds['token']

include_recipe "collectd"
include_recipe "collectd-librato"
