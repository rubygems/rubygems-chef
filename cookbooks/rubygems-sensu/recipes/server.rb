#
# Cookbook Name:: rubygems-sensu
# Recipe:: server
#

node.default['uchiwa']['version'] = '0.3.4-1'
node.default['uchiwa']['settings']['user'] = ''
node.default['uchiwa']['settings']['pass'] = ''
node.default['sensu']['use_embedded_ruby'] = true
node.default['sensu']['use_ssl'] = false

sensu_handler 'default' do
  type 'pipe'
  command 'cat'
end

include_recipe 'rubygems-sensu::librato'
include_recipe 'rubygems-sensu::slack'
include_recipe 'rubygems-sensu::pagerduty'

include_recipe 'sensu::rabbitmq'

apt_preference 'rabbitmq-server' do
  pin 'version 3.1.5'
  pin_priority '700'
end

include_recipe 'sensu::redis'
include_recipe 'sensu::server_service'
include_recipe 'sensu::api_service'
include_recipe 'uchiwa'

include_recipe 'rubygems-sensu::app'
include_recipe 'rubygems-sensu::balancer'
include_recipe 'rubygems-sensu::base'
include_recipe 'rubygems-sensu::cache'
include_recipe 'rubygems-sensu::database'
include_recipe 'rubygems-sensu::nginx'
