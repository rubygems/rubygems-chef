#
# Cookbook Name:: rubygems-sensu
# Recipe:: default
#

# change this once we have the vault setup
node.default['sensu']['use_ssl'] = false

include_recipe 'sensu'

# this will only ever return a single 'ip' key since node comes from
# the node name and is therefore unique.
monitoring_host = search('node', 'name:monitoring01.common.rubygems.org')

# set the address of the host to the local ipaddress if the node doesn't
# exist in chef's index yet since it's being boostrapped.
address = monitoring_host.first['ipaddress']

node.default['sensu']['api']['host'] = address
node.default['sensu']['rabbitmq']['host'] = address
node.default['sensu']['rabbitmq']['port'] = 5672
node.default['sensu']['redis']['host'] = address
node.default['sensu']['redis']['port'] = 6379

sensu_client node.name do
  address node['ipaddress']
  subscriptions node['roles'] + ['all']
  additional(environment: node.chef_environment)
end

include_recipe 'rubygems-sensu::base'
include_recipe 'rubygems-sensu::balancer'
include_recipe 'rubygems-sensu::app'
include_recipe 'rubygems-sensu::nginx'
include_recipe 'sensu::client_service'
