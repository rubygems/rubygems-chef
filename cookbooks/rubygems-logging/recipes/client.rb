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

include_recipe 'rubygems-logging::install_filebeat'

node.default['current']['token'] = ''

if ::File.exist?('/var/log/nginx/access.json.log')
  app = node['roles'].include?('balancer') ? 'lb' : 'app'
  current_send 'nginx' do
    filename '/var/log/nginx/access.json.log'
    tags(["environment:#{node.chef_environment}", 'type:nginx', "app:#{app}"])
    action :disable
  end
end

if ::File.exist?('/var/log/nginx')
  app = node['roles'].include?('balancer') ? 'lb' : 'app'
  current_send 'nginx_error' do
    filename '/var/log/nginx/error.log'
    tags(["environment:#{node.chef_environment}", 'type:nginx_error', "app:#{app}"])
    action :disable
  end
end

if ::File.exist?('/var/log/unicorn')
  current_send 'unicorn' do
    filename '/var/log/unicorn/current'
    tags(["environment:#{node.chef_environment}", 'type:unicorn'])
    action :disable
  end
end

if ::File.exist?('/applications/rubygems')
  current_send 'rails' do
    filename "/applications/rubygems/shared/log/#{node.chef_environment}.log"
    tags(["environment:#{node.chef_environment}", 'type:rails'])
    action :disable
  end
end

if ::File.exist?('/applications/rubygems')
  current_send 'delayed_job' do
    filename '/applications/rubygems/shared/log/delayed_job.log'
    tags(["environment:#{node.chef_environment}", 'type:delayed_job'])
    action :disable
  end
end
