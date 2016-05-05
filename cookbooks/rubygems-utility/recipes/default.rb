#
# Cookbook Name:: rubygems-utility
# Recipe:: default
#

# This needs to get run before we install any packages because the apt cache
# might be out of date and the default apt recipe will update it.
include_recipe 'apt'

packages_bag = data_bag_item('packages', 'base')

packages_bag['packages'].each do |pkg|
  package pkg
end

packages_bag['banned_packages'].each do |name|
  package name do
    action :purge
    only_if "dpkg -s '#{name}'"
  end
end
