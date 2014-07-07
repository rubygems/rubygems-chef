#
# Cookbook Name:: rubygems-cloud-init
# Recipe:: default
#

cookbook_file 'cloud.cfg' do
  path '/etc/cloud/cloud.cfg'
end
