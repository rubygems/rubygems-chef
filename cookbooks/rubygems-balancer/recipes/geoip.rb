#
# Cookbook Name:: rubygems-balancer
# Recipe:: geoip
#

file "#{node['nginx']['dir']}/conf.d/geoip.conf" do
  action :delete
end

file "#{node['nginx']['dir']}/conf.d/geoip_continent.conf" do
  action :delete
end
