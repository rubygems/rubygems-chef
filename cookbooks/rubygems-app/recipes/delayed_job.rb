#
# Cookbook Name:: rubygems-app
# Recipe:: delayed_job
#

runit_service 'delayed_job' do
  env node['environment_variables']
  action ::File.exists?('/applications/rubygems/current') ? :enable : :disable
end
