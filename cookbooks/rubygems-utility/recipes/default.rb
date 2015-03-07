#
# Cookbook Name:: rubygems-utility
# Recipe:: default
#

# This needs to get run before we install any packages because the apt cache
# might be out of date and the default apt recipe will update it.
include_recipe 'apt'

packages = data_bag_item('packages', 'base')['packages']

packages.each do |pkg|
  package pkg
end
