#
# Cookbook Name:: rubygems-sensu
# Recipe:: balancer
#

sensu_check 'check_nginx_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p 'nginx: master process /usr/sbin/nginx'"
  handlers ['slack']
  subscribers ['balancer']
  interval 30
  additional(notification: 'nginx is not running', occurences: 3)
end

sensu_check 'check_nginx_http' do
  command "/usr/lib/nagios/plugins/check_http -I 127.0.0.1"
  handlers ['slack']
  subscribers ['balancer']
  interval 30
  additional(notification: 'nginx is not returning 200 OK on port 80', occurences: 3)
end

sensu_check 'check_nginx_https' do
  command "/usr/lib/nagios/plugins/check_http -I 127.0.0.1 --ssl"
  handlers ['slack']
  subscribers ['balancer']
  interval 30
  additional(notification: 'nginx is not returning 200 OK on port 443', occurences: 3)
end

sensu_check 'check_nginx_cert_expiration' do
  command "/usr/lib/nagios/plugins/check_http -I 127.0.0.1 --ssl -C 30,14"
  handlers ['slack']
  subscribers ['balancer']
  interval 30
  additional(occurences: 3)
end
