#
# Cookbook Name:: rubygems-redis
# Recipe:: default
#

include_recipe 'rubygems'

include_recipe 'rubygems-redis::volume'

node.default['sysctl']['params']['vm']['overcommit_memory'] = 1
include_recipe 'sysctl::apply'

node.default['redisio']['default_settings']['loglevel'] = 'notice'
node.default['redisio']['default_settings']['maxmemory'] = \
  "#{(node['memory']['total'][0..-3].to_i / 1024) / 1.2}mb"
node.default['redisio']['default_settings']['maxmemorypolicy'] = 'volatile-lru'

include_recipe 'redisio::install'
include_recipe 'redisio::enable'

include_recipe 'rubygems-backups::redis'
