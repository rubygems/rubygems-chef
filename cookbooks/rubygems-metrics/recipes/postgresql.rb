#
# Cookbook Name:: rubygems-metrics
# Recipe:: postgresql
#

dbhostname = data_bag_item('hosts', 'database')['environments'][node.chef_environment]
db_host = search(:node, "name:#{dbhostname}.#{node.chef_environment}.rubygems.org")[0]

template '/etc/collectd/plugins/postgresql.conf' do
  owner 'root'
  group 'root'
  mode '644'
  source 'postgresql.conf.erb'
  variables(
    password: db_host['postgresql']['password']['postgres']
  )
  notifies :restart, 'service[collectd]'
end
