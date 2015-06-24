#
# Cookbook Name:: rubygems-logging
# Recipe:: server
#

node.default['java']['jdk_version'] = '8'
node.default['java']['install_flavor'] = 'oracle'
node.default['java']['oracle']['accept_oracle_download_terms'] = true

node.default['java']['jdk']['8']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz'
node.default['java']['jdk']['8']['x86_64']['checksum'] = '1ad9a5be748fb75b31cd3bd3aa339cac'

include_recipe 'java'

include_recipe 'rubygems-logging::server_elasticsearch'
include_recipe 'rubygems-logging::server_logstash'
include_recipe 'rubygems-logging::server_kibana'
include_recipe 'rubygems-logging::server_nginx'
