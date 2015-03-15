#
# Cookbook Name:: rubygems-sensu
# Recipe:: default
#

node.default['sensu']['version'] = '0.16.0-1'
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
node.default['sensu']['redis']['host'] = address

sensu_client node.name do
  address node['ipaddress']
  subscriptions node['roles'] + ['all']
  additional(environment: node.chef_environment)
end

gem_package 'sensu-plugin' do
  gem_binary '/opt/sensu/embedded/bin/gem'
end

package 'nagios-plugins'

package 'postgresql-client'

%w(
  check-procs.rb
  check_postgres.pl
  check_memcached.pl
  check_apt.sh
).each do |plugin|
  cookbook_file "/etc/sensu/plugins/#{plugin}" do
    source plugin
    path "/etc/sensu/plugins/#{plugin}"
    owner 'sensu'
    group 'sensu'
    mode '0755'
    action :create
  end
end

# make sure no checks are defined on the clients
unless node['name'] == 'monitoring01.common.rubygems.org'
  directory '/etc/sensu/conf.d/checks' do
    action :delete
    recursive true
  end
end

include_recipe 'build-essential'

include_recipe 'sensu::client_service'
