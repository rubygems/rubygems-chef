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
  additional(occurrences: 720) # don't alert until 24 hours have passed since we only run unattended upgrades once per day
end

sensu_check 'check_ntp_time' do
  command '/usr/lib/nagios/plugins/check_ntp_time -H localhost'
  handlers ['slack']
  subscribers ['all']
  interval 120
  additional(occurrences: 3)
end

sensu_check 'check_load' do
  command '/usr/lib/nagios/plugins/check_load -w :::load_thresholds.warning::: -c :::load_thresholds.critical:::'
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(occurrences: 3)
end
