#
# Cookbook Name:: rubygems-logging
# Recipe:: client
#

logging_secrets = chef_vault_item('secrets', 'logging')

node.default['rsyslog']['server_ip'] = logging_secrets['endpoint']
node.default['rsyslog']['port'] = logging_secrets['syslog_port']
node.default['rsyslog']['preserve_fqdn'] = 'on'
node.default['rsyslog']['high_precision_timestamps'] = true
include_recipe 'rsyslog::client'
