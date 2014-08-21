#
# Cookbook Name:: rubygems-sensu
# Recipe:: balancer
#

sensu_check 'check_nginx_http' do
  command '/usr/lib/nagios/plugins/check_http -I 127.0.0.1 -t 5 -w 1 -c 2'
  handlers ['slack', 'pagerduty']
  subscribers ['balancer']
  interval 30
  additional(notification: "[#{node.chef_environment}] nginx is not returning 200 OK on port 80", occurrences: 3)
end

sensu_check 'check_nginx_https' do
  command '/usr/lib/nagios/plugins/check_http -I 127.0.0.1 --ssl -t 5 -w 1 -c 2'
  handlers ['slack', 'pagerduty']
  subscribers ['balancer']
  interval 30
  additional(notification: "[#{node.chef_environment}] nginx is not returning 200 OK on port 443", occurrences: 3)
end

sensu_check 'check_nginx_cert_expiration' do
  command '/usr/lib/nagios/plugins/check_http -I 127.0.0.1 --ssl -C 30,14'
  handlers ['slack', 'pagerduty']
  subscribers ['balancer']
  interval 30
  additional(occurrences: 3)
end
