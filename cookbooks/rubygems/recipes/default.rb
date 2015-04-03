#
# Cookbook Name:: rubygems
# Recipe:: default
#

ruby_block 'check chef-client-stopped tag' do
  block do
    if node['tags'].include?('chef-client-stopped')
      Chef::Log.debug('Stopping chef run because chef-client-stopped tag exists.')
      Process.exit!(true)
    end
  end
end

include_recipe 'rubygems-apt'
include_recipe 'rubygems-chef'
include_recipe 'rubygems-cloud-init'
include_recipe 'rubygems-hostname'
include_recipe 'rubygems-hosts'
include_recipe 'rubygems-logging'
include_recipe 'rubygems::datadog'
include_recipe 'rubygems-motd'
include_recipe 'rubygems-ntp'
include_recipe 'rubygems-ruby'
include_recipe 'rubygems-utility'
include_recipe 'rubygems-people'
include_recipe 'rubygems-sensu'
include_recipe 'rubygems-ssh'

directory '/applications'
