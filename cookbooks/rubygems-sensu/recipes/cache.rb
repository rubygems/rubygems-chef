include_recipe 'build-essential'
include_recipe 'cpan'

cpan_client 'Cache::Memcached' do
  user 'root'
  group 'root'
  force true
  install_type 'cpan_module'
  action 'install'
end

cpan_client 'String::CRC32' do
  user 'root'
  group 'root'
  force true
  install_type 'cpan_module'
  action 'install'
end

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
