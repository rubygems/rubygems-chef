#
# Cookbook Name:: rubygems-balancer
# Recipe:: geoip
#

template "#{node['nginx']['dir']}/conf.d/geoip.conf" do
  source 'nginx-geoip.conf.erb'
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :restart, 'service[nginx]', :immediately
end

cookbook_file "#{node['nginx']['dir']}/conf.d/geoip_continent.conf" do
  source 'geoip_continent.conf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]', :immediately
end
