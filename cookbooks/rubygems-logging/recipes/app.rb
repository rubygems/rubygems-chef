#
# Cookbook Name:: rubygems-logging
# Recipe:: app
#

%w(
  /etc/datadog-agent
  /etc/datadog-agent/conf.d
  /etc/datadog-agent/conf.d/ruby.d
).each do |path|
  directory path do
    owner 'dd-agent'
    group 'dd-agent'
  end
end

template '/etc/datadog-agent/conf.d/ruby.d/conf.yml' do
  source 'app.yml.erb'
  notifies :restart, 'service[datadog-agent]'
end
