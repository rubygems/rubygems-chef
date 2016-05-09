#
# Cookbook Name:: rubygems-logging
# Recipe:: install_filebeat
#

apt_repository 'beats' do
  uri 'https://packages.elastic.co/beats/apt'
  components %w(stable main)
  key 'https://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  distribution ''
end

package 'filebeat' do
  notifies :restart, 'service[filebeat]'
end

service 'filebeat' do
  action [:enable, :start]
end
