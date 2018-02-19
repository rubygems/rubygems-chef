#
# Cookbook Name:: rubygems-logging
# Recipe:: install_filebeat
#

service 'filebeat' do
  action [:disable, :stop]
end

package 'filebeat' do
  action :remove
end

directory '/etc/filebeat' do
  action :delete
  recursive true
end
