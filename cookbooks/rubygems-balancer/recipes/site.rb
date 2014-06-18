#
# Cookbook Name:: rubygems-balancer
# Recipe:: site
#

template "#{node['nginx']['dir']}/sites-available/rubygems" do
  source 'site.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  variables(
    app_servers:  search(:node, "app01.#{node.chef_environment}.rubygems.org"),
    stat_server:  search(:node, 'roles:stat')[0],
    server_names: ['rubygems.org', 'www.rubygems.org'],
    ssl_key:      File.join(node['nginx']['dir'], 'certs', 'rubygems.org.key'),
    ssl_cert:     File.join(node['nginx']['dir'], 'certs', 'rubygems.org.crt')
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'rubygems'
