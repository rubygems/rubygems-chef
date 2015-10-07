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

dpkg_package 'logstash-forwarder' do
  action :remove
end

# if ::File.exist?('/var/log/nginx/access.json.log')
#   config['files'] << {
#     paths: ['/var/log/nginx/access.json.log'],
#     fields: { type: 'nginx_json' }
#   }
# end
#
# if ::File.exist?('/var/log/nginx')
#   config['files'] << {
#     paths: ['/var/log/nginx/error.log'],
#     fields: { type: 'nginx_error' }
#   }
# end
#
# if ::File.exist?('/var/log/unicorn')
#   config['files'] << {
#     paths: ['/var/log/unicorn/current'],
#     fields: { type: 'unicorn' }
#   }
# end
#
# if ::File.exist?('/applications/rubygems')
#   config['files'] << {
#     paths: ['/applications/rubygems/shared/log/staging.log'],
#     fields: { type: 'rails' }
#   }
# end

# if ::File.exist?('/applications/rubygems')
#   config['files'] << {
#     paths: ['/applications/rubygems/shared/log/delayed_job.log'],
#     fields: { type: 'delayed_job' }
#   }
# end

file '/etc/logstash-forwarder.conf' do
  action :delete
end
