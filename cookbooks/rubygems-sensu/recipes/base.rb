#
# Cookbook Name:: rubygems-sensu
# Recipe:: base
#

sensu_check 'check_procs' do
  command '/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb'
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(occurrences: 3)
end

sensu_check 'check_ntpd_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p '/usr/sbin/ntpd -p /var/run/ntpd.pid'"
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(occurrences: 3)
end

sensu_check 'check_collectd_proc' do
  action :delete
end

sensu_check 'check_ssh' do
  command '/usr/lib/nagios/plugins/check_ssh localhost'
  handlers ['slack', 'pagerduty']
  subscribers ['all']
  interval 30
  additional(occurrences: 3)
end

sensu_check 'check_apt' do
  command '/etc/sensu/plugins/check_apt.sh'
  handlers ['slack']
  subscribers ['all']
  interval 120
  additional(occurrences: 30)
end

sensu_check 'check_ntp_time' do
  command '/usr/lib/nagios/plugins/check_ntp_time -H localhost'
  handlers ['slack']
  subscribers ['all']
  interval 120
  additional(occurrences: 3)
end

sensu_check 'check_load' do
  command "/usr/lib/nagios/plugins/check_load -w #{node['cpu']['total'] * 8}:#{node['cpu']['total'] * 5}:#{node['cpu']['total'] * 2} -c #{node['cpu']['total'] * 10}:#{node['cpu']['total'] * 8}:#{node['cpu']['total'] * 3}"
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(occurrences: 3)
end
