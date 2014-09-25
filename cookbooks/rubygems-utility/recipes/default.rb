#
# Cookbook Name:: rubygems-utility
# Recipe:: default
#

packages = data_bag_item('packages', 'base')['packages']

packages.each do |pkg|
  package pkg
end

package 'bash' do
  case node['lsb']['codename']
  when 'trusty'
    version '4.3-7ubuntu1.1'
  end
end
