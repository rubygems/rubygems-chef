#
# Cookbook Name:: rubygems-logging
# Recipe:: balancer
#

include_recipe 'rubygems-logging::filebeat'

logging_secrets = chef_vault_item('secrets', 'logging')

template '/etc/filebeat/filebeat.yml' do
  source 'filebeat/balancer.yml.erb'
  variables(
    logstash_endpoint: "#{logging_secrets['endpoint']}:#{logging_secrets['beats_port']}"
  )
  notifies :restart, 'service[filebeat]'
end
