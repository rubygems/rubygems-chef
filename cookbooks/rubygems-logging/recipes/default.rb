#
# Cookbook Name:: rubygems-logging
# Recipe:: default
#

include_recipe 'rubygems-logging::syslog'
include_recipe 'rubygems-logging::balancer' if node['roles'].include?('balancer')
include_recipe 'rubygems-logging::app' if node['roles'].include?('app')
# include_recipe 'rubygems-logging::app' if node['roles'].include?('jobs')
