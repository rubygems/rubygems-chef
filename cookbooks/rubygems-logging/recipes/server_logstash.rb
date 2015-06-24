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

node.default['logstash']['instance']['server']['version']            = '1.5.1'
node.default['logstash']['instance']['server']['source_url']         = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.5.1.tar.gz'
node.default['logstash']['instance']['server']['checksum']           = 'a12f91bc87f6cd8f1b481c9e9d0370a650b2c36fdc6a656785ef883cb1002894'
node.default['logstash']['instance']['server']['gc_opts']            = <<-CONFIG
  -XX:+UseG1GC
  -XX:+HeapDumpOnOutOfMemoryError
CONFIG
node.default['logstash']['instance']['server']['java_home']          = '/usr/lib/jvm/java-8-oracle-amd64'

name = 'server'
logstash_instance name do
  action 'create'
end
logstash_service name do
  action [:enable, :start]
  templates_cookbook 'rubygems-logging'
end
logstash_pattern name do
  action 'create'
end
logstash_curator name do
  action 'create'
end

# Since logstash 1.5.0, outputs/inputs/filters are separate plugins
%w(
  logstash-filter-mutate logstash-filter-grok logstash-filter-date logstash-filter-geoip logstash-output-elasticsearch
  logstash-input-lumberjack logstash-input-syslog
).each do |plugin|
  logstash_plugins plugin do
    action 'create'
    instance name
  end
end

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
