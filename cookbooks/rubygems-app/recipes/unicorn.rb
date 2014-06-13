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

redis_ip = search(:node, "chef_environment:#{node.chef_environment} AND role:redis")[0]['ipaddress']

runit_service 'unicorn' do
  owner 'deploy'
  group 'deploy'
  options(
    name: 'rubygems',
    owner: 'deploy',
    group: 'deploy',
    redis_url: "redis://#{redis_ip}:6379/0",
    bundler: true,
    bundle_command: '/usr/local/bin/bundle',
    rails_env: node.chef_environment,
    smells_like_rack: ::File.exist?('/applications/rubygems/current/config.ru')
  )
  action ::File.exist?('/applications/rubygems/current') ? :enable : :disable
end
