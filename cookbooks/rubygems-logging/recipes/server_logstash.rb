#
# Cookbook Name:: rubygems-logging
# Recipe:: server_logstash
#

directory '/etc/pki/tls/certs/logstash-forwarder' do
  recursive true
end

directory '/etc/pki/tls/private/logstash-forwarder' do
  recursive true
end

item = chef_vault_item('certs', 'logstash')

file '/etc/pki/tls/certs/logstash-forwarder/lumberjack.crt' do
  content item['crt']
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :restart, 'logstash_service[server]', :delayed
end

file '/etc/pki/tls/private/logstash-forwarder/lumberjack.key' do
  content item['key']
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :restart, 'logstash_service[server]', :delayed
end

include_recipe 'logstash::server'

custom_templates = {
  'inputs'               => 'logstash/inputs.conf.erb',
  'filters'              => 'logstash/filters.conf.erb',
  'output_elasticsearch' => 'logstash/output_elasticsearch.conf.erb'
}

logstash_config 'server' do
  action 'create'
  templates_cookbook 'rubygems-logging'
  templates custom_templates
  notifies :restart, 'logstash_service[server]', :delayed
end
