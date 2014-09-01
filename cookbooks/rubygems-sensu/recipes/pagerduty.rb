#
# Cookbook Name:: rubygems-sensu
# Recipe:: pagerduty
#

include_recipe 'chef-vault'

pagerduty_creds = chef_vault_item('sensu', 'credentials')['pagerduty']

template '/etc/sensu/conf.d/pagerduty.json' do
  source 'pagerduty.json.erb'
  owner 'sensu'
  group 'sensu'
  variables(
    api_key: pagerduty_creds['api_key']
  )
end

gem_package 'redphone' do
  gem_binary '/opt/sensu/embedded/bin/gem'
end

cookbook_file '/etc/sensu/handlers/pagerduty.rb' do
  path '/etc/sensu/handlers/pagerduty.rb'
  source 'pagerduty.rb'
  mode '0755'
  action :create
end

sensu_handler 'pagerduty' do
  type 'pipe'
  command 'pagerduty.rb'
  severities ['ok', 'critical']
end
