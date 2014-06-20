#
# Cookbook Name:: rubygems-sensu
# Recipe:: librato
#

include_recipe 'chef-vault'

librato_creds = chef_vault_item('librato', 'credentials')

template '/etc/sensu/librato-metrics.json' do
  source 'librato-metrics.json.erb'
  path '/etc/sensu/librato-metrics.json'
  owner 'sensu'
  group 'sensu'
  variables(
    email: librato_creds['email'],
    api_key: librato_creds['token']
  )
end

cookbook_file '/etc/sensu/handlers/librato-metrics.rb' do
  path '/etc/sensu/handlers/librato-metrics.rb'
  source 'librato-metrics.rb'
  action :create
end
