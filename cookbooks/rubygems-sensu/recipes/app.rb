#
# Cookbook Name:: rubygems-sensu
# Recipe:: app
#

sensu_check 'check_app_nginx_http' do
  command '/usr/lib/nagios/plugins/check_http -I 127.0.0.1 -p 9000 -t 5 -w 1 -c 2'
  handlers ['slack']
  subscribers ['app']
  interval 30
  additional(notification: 'nginx is not returning 200 OK on port 9000', occurences: 3)
end

sensu_check 'check_unicorn_http' do
  command '/usr/lib/nagios/plugins/check_http -I 127.0.0.1 -p 3000 -t 5 -w 1 -c 2'
  handlers ['slack']
  subscribers ['app']
  interval 30
  additional(notification: 'unicorn is not returning 200 OK on port 3000', occurences: 3)
end

sensu_check 'check_unicorn_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p 'unicorn master'"
  handlers ['slack']
  subscribers ['app']
  interval 30
  additional(notification: 'unicorn is not running', occurences: 3)
end
