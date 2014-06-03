#
# Cookbook Name:: rubygems-balancer
# Recipe:: maintenance
#

cookbook_file "#{node['nginx']['dir']}/maintenance.html" do
  source 'maintenance.html'
  owner 'root'
  group 'root'
  mode '0644'
end
