#
# Cookbook Name:: rubygems-hosts
# Recipe:: default
#

hosts = search(:node, '*.*')

template '/etc/hosts' do
  source 'hosts.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    hosts: hosts,
    hostname: node[:hostname],
    fqdn: node[:fqdn],
    machinename: node[:machinename]
  )
end
