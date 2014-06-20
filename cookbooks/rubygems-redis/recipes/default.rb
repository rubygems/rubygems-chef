#
# Cookbook Name:: rubygems-redis
# Recipe:: default
#

include_recipe 'rubygems'

include_recipe 'redisio::install'
include_recipe 'redisio::enable'
