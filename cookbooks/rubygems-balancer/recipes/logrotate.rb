#
# Cookbook Name:: rubygems-balancer
# Recipe:: logrotate
#

logrotate_app 'nginx' do
  path "#{node['nginx']['log_dir']}/*.log"
  frequency 'daily'
  rotate 52
  options %w(missingok compress delaycompress notifempty sharedscripts)
  postrotate "    [ -f #{node['nginx']['pid']} ] && kill -USR1 `cat #{node['nginx']['pid']}`"
  create '0640 www-data adm'
end
