#
# Cookbook Name:: rubygems-apt
# Recipe:: default
#

node.default['apt']['bootstrap'] = false

# We use /etc/apt/sources.list.d/ for everything.
file '/etc/apt/sources.list' do
  content ''
  not_if { node['apt']['bootstrap'] }
end

cookbook_file 'ubuntu.list' do
  path '/etc/apt/sources.list.d/ubuntu.list'
end

file '/etc/apt/apt.conf.d/05unauthenticated' do
  action :delete
end

cookbook_file '/etc/apt/apt.conf.d/50unattended-upgrades'

template '/etc/apt/apt.conf.d/20auto-upgrades'
