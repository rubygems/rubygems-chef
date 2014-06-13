#
# Cookbook Name:: rubygems-app
# Recipe:: default
#

include_recipe 'apt'
package 'git'
node.default['nodejs']['install_method'] = 'package'
include_recipe 'nodejs'
include_recipe 'runit'
include_recipe 'rubygems-app::memcached'
package 'libpq-dev'
gem_package 'bundler'

include_recipe 'rubygems-app::deploy_user'
include_recipe 'rubygems-app::dirs'
include_recipe 'rubygems-app::config'
include_recipe 'rubygems-app::unicorn'
include_recipe 'rubygems-app::delayed_job'
include_recipe 'rubygems-app::nginx'
