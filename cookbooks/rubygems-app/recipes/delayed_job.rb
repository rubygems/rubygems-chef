#
# Cookbook Name:: rubygems-app
# Recipe:: delayed_job
#

runit_service 'delayed_job' do
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

sudo 'deploy-delayed_job' do
  user 'deploy'
  commands [
    '/etc/init.d/delayed_job *',
    '/usr/sbin/service delayed_job *',
    '/usr/bin/sv -w * delayed_job'
  ]
  nopasswd true
end
