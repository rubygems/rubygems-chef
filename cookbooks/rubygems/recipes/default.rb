#
# Cookbook Name:: rubygems
# Recipe:: default
#

include_recipe 'rubygems-apt'
include_recipe 'rubygems-chef'
include_recipe 'rubygems-cloud-init'
include_recipe 'rubygems-hostname'
include_recipe 'rubygems-hosts'
include_recipe 'rubygems-logging'
include_recipe 'rubygems-metrics'
include_recipe 'rubygems-motd'
include_recipe 'rubygems-ntp'
include_recipe 'rubygems-people'
include_recipe 'rubygems-sensu'
include_recipe 'rubygems-ssh'
include_recipe 'rubygems-utility'
