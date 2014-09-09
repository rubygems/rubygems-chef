#
# Cookbook Name:: rubygems-sensu
# Recipe:: database
#
if node.chef_environment == 'common'
  search_environment = 'production'
else
  search_environment = node.chef_environment
end

host = data_bag_item('hosts', 'database')['environments'][search_environment]
db_host = search('node', "name:#{host}.#{search_environment}.rubygems.org")[0]
secrets = chef_vault_item('rubygems', search_environment)

db_connection = "-H #{db_host['ipaddress']} --dbuser=#{secrets['rails_postgresql_user']} --dbpass=#{db_host['postgresql']['password']['postgres']} -db rubygems_#{search_environment}"

sensu_check 'check_postgres_proc' do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb -p 'postgres -D'"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(notification: "[#{node.chef_environment}] postgres is not running", occurrences: 3)
end

%w( connection locks timesync commitratio ).each do |check|
  sensu_check "check_postgres_#{check}" do
    command "perl /etc/sensu/plugins/check_postgres.pl --action #{check} #{db_connection}"
    handlers ['slack', 'pagerduty']
    subscribers ['app']
    interval 30
    additional(occurrences: 3)
  end
end

sensu_check 'check_postgres_backends' do
  command "perl /etc/sensu/plugins/check_postgres.pl --action backends -db rubygems_#{node.chef_environment}"
  handlers ['slack', 'pagerduty']
  subscribers ['database']
  interval 30
  additional(occurrences: 3)
end
