#
# Cookbook Name:: rubygems-backups
# Recipe:: _common
#

include_recipe 'chef-vault'

node.default['rubygems']['backups']['config_dir'] = '/var/lib/rubygems-backup'

%w( ruby2.0 ruby2.0-dev ).each do |pkg|
  package pkg
end

link '/usr/bin/ruby' do
  to  '/usr/bin/ruby2.0'
end

link '/usr/bin/gem' do
  to '/usr/bin/gem2.0'
end

gem_package 'backup' do
  version '~> 4.0'
end

directory node['rubygems']['backups']['config_dir'] do
  owner 'root'
  group 'root'
  mode 00755
end
