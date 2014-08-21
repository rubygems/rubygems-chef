#
# Cookbook Name:: rubygems-sensu
# Recipe:: nginx
#

sensu_check 'check_nginx_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p 'nginx: master process /usr/sbin/nginx'"
  handlers ['slack', 'pagerduty']
  subscribers ['balancer', 'app']
  interval 30
  additional(notification: "[#{node.chef_environment}] nginx is not running", occurrences: 3)
end
