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
    command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check_rubygems_ssl.rb -P '/var/lib/gems/2.3.0/gems/bundler-1.12.5/lib/bundler/ssl_certs/*/*.pem' -h #{host}"
    handlers ['slack', 'pagerduty']
    subscribers ['monitoring']
    interval 300
    additional(occurrences: 2)
  end
end
