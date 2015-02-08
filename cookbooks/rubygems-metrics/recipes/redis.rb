#
# Cookbook Name:: rubygems-metrics
# Recipe:: redis
#

node.default['datadog']['redisdb']['instances'] = [
  {
    'server' => 'localhost',
    'tags' => []
  }
]

include_recipe 'datadog::redisdb'
