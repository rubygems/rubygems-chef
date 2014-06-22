include_recipe 'chef-vault'

papertrail_creds = ChefVault::Item.load('papertrail', 'credentials')

node.default['rsyslog']['server_ip'] = papertail_creds['server']
node.default['rsyslog']['port'] = papertrail_creds['port']
node.default['rsyslog']['preserve_fqdn'] = true
node.default['rsyslog']['high_precision_timestamps'] = true

include_recipe 'rsyslog'
