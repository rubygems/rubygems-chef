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

if node.chef_environment == 'staging'
  include_recipe 'current::install'

  current_secrets = chef_vault_item('secrets', 'current')
  node.default['current']['token'] = current_secrets['token']

  if ::File.exist?('/var/log/nginx/access.json.log')
    current_send 'nginx' do
      filename '/var/log/nginx/access.json.log'
      tags(["environment:#{node.chef_environment}", 'type:nginx'])
    end
  end

  if ::File.exist?('/var/log/nginx')
    current_send 'nginx_error' do
      filename '/var/log/nginx/error.log'
      tags(["environment:#{node.chef_environment}", 'type:nginx_error'])
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
      filename '/applications/rubygems/shared/log/staging.log'
      tags(["environment:#{node.chef_environment}", 'type:rails'])
    end
  end

  if ::File.exist?('/applications/rubygems')
    current_send 'delayed_job' do
      filename '/applications/rubygems/shared/log/delayed_job.log'
      tags(["environment:#{node.chef_environment}", 'type:delayed_job'])
    end
  end
end
