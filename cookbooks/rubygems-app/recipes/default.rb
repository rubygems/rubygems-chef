#
# Cookbook Name:: rubygems-app
# Recipe:: default
#

node.default['nodejs']['install_method'] = 'package'

include_recipe 'apt'
include_recipe 'git'
include_recipe 'nodejs'
include_recipe 'runit'
include_recipe 'rubygems-app::ruby'

package 'libpq-dev'

include_recipe 'rubygems-app::deploy_user'
include_recipe 'rubygems-app::dirs'
include_recipe 'rubygems-app::config'
include_recipe 'rubygems-app::unicorn'
include_recipe 'rubygems-app::delayed_job'
include_recipe 'rubygems-app::nginx'
