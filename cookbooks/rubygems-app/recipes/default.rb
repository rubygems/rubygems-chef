#
# Cookbook Name:: rubygems-app
# Recipe:: default
#

include_recipe 'rubygems'

node.default['nodejs']['install_method'] = 'package'

include_recipe 'apt'
include_recipe 'git'
include_recipe 'nodejs'
include_recipe 'runit'
include_recipe 'rubygems-ruby'
include_recipe 'rubygems-ruby::rubygems'
include_recipe 'postfix'

package 'libpq-dev'

include_recipe 'rubygems-people::deploy'
include_recipe 'rubygems-app::dirs'
include_recipe 'rubygems-app::config'
include_recipe 'rubygems-app::unicorn'
include_recipe 'rubygems-app::delayed_job'
include_recipe 'rubygems-app::shoryuken'
include_recipe 'rubygems-app::nginx'
include_recipe 'rubygems-app::logrotate'
