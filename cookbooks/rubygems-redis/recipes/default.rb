#
# Cookbook Name:: rubygems-redis
# Recipe:: default
#

include_recipe 'rubygems'

node.default['redisio']['default_settings']['loglevel'] = 'notice'

include_recipe 'redisio::install'
include_recipe 'redisio::enable'
