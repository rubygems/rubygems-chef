#
# Cookbook Name:: rubygems-apt
# Recipe:: default
#

node.default['apt']['bootstrap'] = false

# We use /etc/apt/sources.list.d/ for everything.
file '/etc/apt/sources.list' do
  action :delete
  not_if { node['apt']['bootstrap'] }
end

file '/etc/apt/apt.conf.d/05unauthenticated' do
  action :delete
end

directory '/etc/apt/rubygems' do
  action :create
end

cookbook_file 'packages.key' do
  path '/etc/apt/rubygems/packages.key'
end

execute 'import-rubygems-apt-key' do
  command '/usr/bin/apt-key add /etc/apt/rubygems/packages.key'
  not_if "/usr/bin/apt-key list | grep '2048R/6B6ABD97'"
end

apt_repository 'rubygems_main' do
  uri 'http://repo01.common.rubygems.org'
  distribution node['lsb']['codename']
  components ['main']
  not_if { node['apt']['bootstrap'] }
end
