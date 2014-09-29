#
# Cookbook Name:: rubygems-utility
# Recipe:: default
#

packages = data_bag_item('packages', 'base')['packages']

packages.each do |pkg|
  package pkg
end

include_recipe 'apt'

package 'bash' do
  case node['lsb']['codename']
  when 'trusty'
    version '4.3-7ubuntu1.4'
  end
  notifies :run, 'execute[run-ldconfig]', :immediately
end

execute 'run-ldconfig' do
  command '/sbin/ldconfig'
  action :nothing
end
