#
# Cookbook Name:: rubygems-utility
# Recipe:: default
#

packages = data_bag_item('packages', 'base')['packages']

packages.each do |pkg|
  package pkg
end
