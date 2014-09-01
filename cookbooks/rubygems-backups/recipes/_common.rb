#
# Cookbook Name:: rubygems-backups
# Recipe:: _common
#

include_recipe 'chef-vault'

node.default['rubygems']['backups']['config_dir'] = '/var/lib/rubygems-backup'

include_recipe 'rubygems-ruby'

gem_package 'backup' do
  version '~> 4.0.2'
end

directory node['rubygems']['backups']['config_dir'] do
  owner 'root'
  group 'root'
  mode 00755
end
