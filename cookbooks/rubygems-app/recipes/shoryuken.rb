#
# Cookbook Name:: rubygems-app
# Recipe:: shoryuken
#

runit_service 'shoryuken' do
  owner 'deploy'
  group 'deploy'
  default_logger true
  env(
    'RAILS_ENV' => node.chef_environment
  )
  options(
    owner: 'deploy',
    group: 'deploy',
    bundle_command: '/usr/local/bin/bundle',
    rails_env: node.chef_environment
  )
  action ::File.exist?('/applications/rubygems/current') ? :enable : :disable
end

sudo 'deploy-shoryuken' do
  user 'deploy'
  commands [
    '/etc/init.d/shoryuken *',
    '/usr/sbin/service shoryuken *',
    '/usr/bin/sv -w * shoryuken'
  ]
  nopasswd true
end
