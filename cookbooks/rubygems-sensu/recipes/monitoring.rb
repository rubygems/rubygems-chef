#
# Cookbook Name:: rubygems-sensu
# Recipe:: monitoring
#

%w(
  rubygems.org
  fastly.rubygems.org
  rubygems.global.ssl.fastly.net
  staging.rubygems.org
  index.rubygems.org
).each do |host|
  sensu_check "check_#{host}_ssl" do
    command "perl /etc/sensu/plugins/check_postgres_backends.rb -P '' -h #{host}"
    handlers ['slack', 'pagerduty']
    subscribers ['app']
    interval 120
    additional(occurrences: 3)
  end
end
