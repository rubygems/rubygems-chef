#
# Cookbook Name:: rubygems-logging
# Recipe:: client
#

log_server = search(:node, 'name:log01.common.rubygems.org')[0]

node.default['rsyslog']['server_ip'] = log_server['ipaddress']
node.default['rsyslog']['port'] = '5959'
node.default['rsyslog']['preserve_fqdn'] = 'on'
node.default['rsyslog']['high_precision_timestamps'] = true
include_recipe 'rsyslog::client'

forwarder_package_file = "#{Chef::Config[:file_cache_path]}/logstash-forwarder_0.4.0_amd64.deb"

remote_file forwarder_package_file do
  action :create
  source 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder_0.4.0_amd64.deb'
  checksum '9f18acbdecc94918353d417eccd01903b0933370196647c32a2498956d8a87ac'
end

dpkg_package 'logstash-forwarder' do
  source forwarder_package_file
end

directory '/etc/pki/tls/certs/logstash-forwarder' do
  recursive true
end

data_bag = chef_vault_item('certs', 'logstash')

file '/etc/pki/tls/certs/logstash-forwarder/lumberjack.crt' do
  content data_bag['crt']
  owner  'root'
  group  'root'
  mode   '0644'
end

config = {
  'network' => {
    'servers' => ["#{log_server['fqdn']}:5043"],
    'ssl ca' => '/etc/pki/tls/certs/logstash-forwarder/lumberjack.crt',
    'timeout' => 15
  },
  'files' => []
}

if ::File.exist?('/var/log/nginx/access.json.log')
  config['files'] << {
    paths: ['/var/log/nginx/access.json.log'],
    fields: { type: 'nginx_json' }
  }
end

if ::File.exist?('/var/log/nginx')
  config['files'] << {
    paths: ['/var/log/nginx/error.log'],
    fields: { type: 'nginx_error' }
  }
end

if ::File.exist?('/var/log/unicorn')
  config['files'] << {
    paths: ['/var/log/unicorn/current'],
    fields: { type: 'unicorn' }
  }
end

if ::File.exist?('/applications/rubygems')
  config['files'] << {
    paths: ['/applications/rubygems/shared/log/staging.log'],
    fields: { type: 'rails' }
  }
end

# if ::File.exist?('/applications/rubygems')
#   config['files'] << {
#     paths: ['/applications/rubygems/shared/log/delayed_job.log'],
#     fields: { type: 'delayed_job' }
#   }
# end

file '/etc/logstash-forwarder.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  content JSON.pretty_generate(config)
  notifies config['files'].empty? ? :stop : :restart, 'service[logstash-forwarder]'
end

service 'logstash-forwarder' do
  supports :status => true, :restart => true, :reload => true
  action config['files'].empty? ? [:disable, :stop] : [:enable, :start]
end
