#
# Cookbook Name:: rubygems-sensu
# Recipe:: database
#

sensu_check 'check_postgres_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p 'postgres -D'"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(notification: 'postgres is not running', occurences: 3)
end

sensu_check 'check_postgres_connection' do
  command "perl check_postgres.pl --action connection -db rubygems_#{node.chef_environment}"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(occurences: 3)
end

sensu_check 'check_postgres_backends' do
  command "perl check_postgres.pl --action backends -db rubygems_#{node.chef_environment}"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(occurences: 3)
end
