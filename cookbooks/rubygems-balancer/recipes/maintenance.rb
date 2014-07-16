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

directory '/var/www/rubygems' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end
