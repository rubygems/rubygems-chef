#
# Cookbook Name:: rubygems-logging
# Recipe:: server
#

node.default['java']['install_flavor'] = 'openjdk'
node.default['java']['jdk_version'] = '7'
include_recipe 'java'

include_recipe 'rubygems-logging::server_elasticsearch'
include_recipe 'rubygems-logging::server_logstash'
include_recipe 'rubygems-logging::server_kibana'
include_recipe 'rubygems-logging::server_nginx'
