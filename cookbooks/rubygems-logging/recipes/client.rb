#
# Cookbook Name:: rubygems-logging
# Recipe:: client
#

# node.default['rsyslog']['server_ip'] = log_server['ipaddress']
# node.default['rsyslog']['port'] = '5959'
# node.default['rsyslog']['preserve_fqdn'] = 'on'
# node.default['rsyslog']['high_precision_timestamps'] = true
# include_recipe 'rsyslog::client'
file "#{node['rsyslog']['config_prefix']}/rsyslog.d/49-remote.conf" do
  action :delete
end

include_recipe 'current::install'

current_secrets = chef_vault_item('secrets', 'current')
node.default['current']['token'] = current_secrets['token']

if ::File.exist?('/var/log/nginx/access.json.log')
  app = node['roles'].include?('balancer') ? 'lb' : 'app'
  current_send 'nginx' do
    filename '/var/log/nginx/access.json.log'
    tags(["environment:#{node.chef_environment}", 'type:nginx', "app:#{app}"])
  end
end

if ::File.exist?('/var/log/nginx')
  app = node['roles'].include?('balancer') ? 'lb' : 'app'
  current_send 'nginx_error' do
    filename '/var/log/nginx/error.log'
    tags(["environment:#{node.chef_environment}", 'type:nginx_error', "app:#{app}"])
  end
end

if ::File.exist?('/var/log/unicorn')
  current_send 'unicorn' do
    filename '/var/log/unicorn/current'
    tags(["environment:#{node.chef_environment}", 'type:unicorn'])
  end
end

if ::File.exist?('/applications/rubygems')
  current_send 'rails' do
    filename "/applications/rubygems/shared/log/#{node.chef_environment}.log"
    tags(["environment:#{node.chef_environment}", 'type:rails'])
  end
end

if ::File.exist?('/applications/rubygems')
  current_send 'delayed_job' do
    filename '/applications/rubygems/shared/log/delayed_job.log'
    tags(["environment:#{node.chef_environment}", 'type:delayed_job'])
  end
end
