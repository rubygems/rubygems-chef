#
# Cookbook Name:: rubygems-sensu
# Recipe:: app
#

sensu_check 'check_app_nginx_http' do
  command '/usr/lib/nagios/plugins/check_http -I 127.0.0.1 -p 9000'
  handlers ['slack']
  subscribers ['app']
  interval 30
  additional(notification: 'nginx is not returning 200 OK on port 9000', occurences: 3)
end
