#
# Cookbook Name:: rubygems
# Recipe:: default
#

include_recipe 'rubygems-hostname'
include_recipe 'rubygems-hosts'
include_recipe 'rubygems-motd'
include_recipe 'rubygems-ntp'
include_recipe 'rubygems-people'
include_recipe 'rubygems-utility'
