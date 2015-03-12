#
# Cookbook Name:: rubygems-balancer
# Recipe:: mounts
#

log_device = '/dev/xvdp'

mount '/var/log/nginx' do
  device log_device
  fstype 'ext4'
  options 'defaults,discard'
  action :mount
  only_if { ::File.exist?(log_device) }
end
