#
# Cookbook Name:: rubygems-app
# Recipe:: unicorn
#

unicorn_config '/etc/unicorn/rubygems.rb' do
  listen('3000' => {})
  working_directory '/applications/rubygems/current'
  worker_processes [node.fetch('cpu', {}).fetch('total', 1).to_i * 4, 8].min
  before_fork 'sleep 1'
end

redis_host = data_bag_item('hosts', 'redis')['environments'][node.chef_environment]
redis_ip = search('node', "name:#{redis_host}.#{node.chef_environment}.rubygems.org")[0]['ipaddress']

include_recipe 'chef-vault'

runit_service 'unicorn' do
  owner 'deploy'
  group 'deploy'
  default_logger true
  env(
    'RAILS_ENV' => node.chef_environment,
    'REDISTOGO_URL' => "redis://#{redis_ip}:6379/0",
    'STATSD_IMPLEMENTATION' => 'datadog'
  )
  options(
    owner: 'deploy',
    group: 'deploy',
    bundle_command: '/usr/local/bin/bundle',
    rails_env: node.chef_environment,
    smells_like_rack: ::File.exist?('/applications/rubygems/current/config.ru')
  )
  action ::File.exist?('/applications/rubygems/current') ? :enable : :disable
end

sudo 'deploy-unicorn' do
  user 'deploy'
  commands [
    '/etc/init.d/unicorn *',
    '/usr/sbin/service unicorn *'
  ]
  nopasswd true
end
