#
# Cookbook Name:: rubygems-logging
# Recipe:: default
#

include_recipe 'chef-vault'

papertrail_creds = chef_vault_item('papertrail', 'credentials')

node.default['rsyslog']['server_ip'] = papertrail_creds['server']
node.default['rsyslog']['port'] = papertrail_creds['port']
node.default['rsyslog']['preserve_fqdn'] = 'on'
node.default['rsyslog']['high_precision_timestamps'] = true

include_recipe 'rsyslog::client'
