#
# Cookbook Name:: rubygems-redis
# Recipe:: default
#

include_recipe 'rubygems-base'

include_recipe 'rubygems-redis::volume'

node.default['sysctl']['params']['vm']['overcommit_memory'] = 1
include_recipe 'sysctl::apply'

node.default['redisio']['default_settings']['loglevel'] = 'notice'

include_recipe 'redisio::install'
include_recipe 'redisio::enable'

include_recipe 'rubygems-backups::redis'

node.default['datadog']['redisdb']['instances'] = [
  {
    'server' => 'localhost',
    'tags' => []
  }
]

include_recipe 'datadog::redisdb'
