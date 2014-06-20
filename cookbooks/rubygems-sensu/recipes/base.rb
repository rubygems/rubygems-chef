#
# Cookbook Name:: rubygems-sensu
# Recipe:: base
#

gem_package 'sensu-plugin' do
  gem_binary '/opt/sensu/embedded/bin/gem'
end

package 'nagios-plugins'

%w( check-procs.rb ).each do |plugin|
  cookbook_file "/etc/sensu/plugins/#{plugin}" do
    source plugin
    path "/etc/sensu/plugins/#{plugin}"
    owner 'sensu'
    group 'sensu'
    mode '0755'
    action :create
  end
end

sensu_check 'check_procs' do
  command '/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb'
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(notification: 'There is a high number of procs running', occurences: 3)
end

sensu_check 'check_chef_client_proc' do
  command "ruby check-procs.rb -p '/usr/bin/chef-client -d -P /var/run/chef/client.pid'"
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(notification: 'chef-client is not running', occurences: 3)
end

sensu_check 'check_ssh' do
  command '/usr/lib/nagios/plugins/check_ssh localhost'
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(notification: 'sshd is not running', occurences: 3)
end

sensu_check 'check_apt' do
  command '/usr/lib/nagios/plugins/check_apt'
  handlers ['slack']
  subscribers ['all']
  interval 60
  additional(notification: 'There are pending package upgrades', occurences: 3)
end

sensu_check 'check_ntp_time' do
  command '/usr/lib/nagios/plugins/check_ntp_time -H localhost'
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(notification: 'NTP is out of sync', occurences: 3)
end

sensu_check 'check_load' do
  command "/usr/lib/nagios/plugins/check_load -w #{node['cpu']['total'] * 8}:#{node['cpu']['total'] * 5}:#{node['cpu']['total'] * 2} -c #{node['cpu']['total'] * 10}:#{node['cpu']['total'] * 8}:#{node['cpu']['total'] * 3}"
  handlers ['slack']
  subscribers ['all']
  interval 30
  additional(notification: 'Load is high', occurences: 3)
end
