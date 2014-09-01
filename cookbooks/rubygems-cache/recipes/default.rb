#
# Cookbook Name:: rubygems-cache
# Recipe:: default
#

include_recipe 'rubygems'

# TODO: look at key eviction in production and properly tune this.
node.default['memcached']['memory'] = 128
node.default['memcached']['user'] = 'memcache'
node.default['memcached']['port'] = 11211
node.default['memcached']['listen'] = '0.0.0.0'

include_recipe 'memcached'
include_recipe 'rubygems-sensu::cache'
