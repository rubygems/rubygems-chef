#
# Cookbook Name:: rubygems-app
# Recipe:: memcached
#

node.default['memcached']['memory'] = 128
node.default['memcached']['user'] = 'memcache'
node.default['memcached']['port'] = 11211
node.default['memcached']['listen'] = '127.0.0.1'

include_recipe 'memcached'
