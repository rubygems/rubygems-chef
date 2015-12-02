#
# Cookbook Name:: rubygems-app
# Recipe:: logrotate
#

logrotate_app 'rails' do
  path "/applications/rubygems/shared/log/*.log"
  su 'deploy deploy'
  frequency 'daily'
  rotate 15
  options %w(missingok nocreate compress delaycompress dateext notifempty sharedscripts)
  postrotate [
    '    [ -f /etc/service/unicorn/supervise/pid ] && kill -USR1 `cat /etc/service/unicorn/supervise/pid`',
    '    [ -f /etc/service/delayed_job/supervise/pid ] && kill -USR1 `cat /etc/service/delayed_job/supervise/pid`'
  ]
end
