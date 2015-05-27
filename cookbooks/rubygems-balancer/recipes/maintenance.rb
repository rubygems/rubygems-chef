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

sudo 'deploy-maintenance' do
  user      'deploy'
  nopasswd  true
  commands  [
    '/bin/ln -s /etc/nginx/maintenance.html /var/www/rubygems/maintenance.html',
    '/bin/rm /var/www/rubygems/maintenance.html'
  ]
end
