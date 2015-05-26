#
# Cookbook Name:: rubygems-shipit
# Recipe:: default
#

node.default['nodejs']['install_method'] = 'package'

include_recipe 'apt'
include_recipe 'git'
include_recipe 'nodejs'
include_recipe 'runit'

gem_package 'heroku'

include_recipe 'rubygems-people::deploy'
include_recipe 'rubygems-shipit::setup'
include_recipe 'rubygems-shipit::app'
include_recipe 'rubygems-shipit::nginx'
