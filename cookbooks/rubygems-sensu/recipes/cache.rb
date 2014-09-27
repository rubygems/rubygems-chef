#
# Cookbook Name:: rubygems-sensu
# Recipe:: cache
#

sensu_check 'check_memcached_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p 'memcached -v'"
  handlers ['slack', 'pagerduty']
  subscribers ['cache']
  interval 30
  additional(notification: "memcached is not running for #{node.chef_environment}", occurences: 3)
end

sensu_check 'check_memcached' do
  command 'perl /etc/sensu/plugins/check_memcached.pl -H localhost'
  handlers ['slack', 'pagerduty']
  subscribers ['cache']
  interval 30
  additional(notification: "memcached is not accepting connections for #{node.chef_environment}", occurences: 3)
end
