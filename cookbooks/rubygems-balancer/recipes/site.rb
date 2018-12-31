#
# Cookbook Name:: rubygems-balancer
# Recipe:: site
#

cookbook_file "#{node['nginx']['dir']}/filters.conf" do
  source 'filters.conf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]', :immediately
end

file "#{node['nginx']['dir']}/blacklist.conf" do
  action :create_if_missing
  owner 'root'
  group 'root'
  mode '0644'
end

fastly_domain = node.chef_environment == 'production' ? 'rubygems' : 'rubygems-staging'

template "#{node['nginx']['dir']}/sites-available/rubygems" do
  source 'site.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  variables(
    app_servers: search(:node, "roles:app AND chef_environment:#{node.chef_environment} AND in_rotation:true").sort,
    k8s_endpoints: (node['k8s_unicorn_endpoints'] || []),
    server_names: ['rubygems.org', 'www.rubygems.org'],
    ssl_key:      File.join(node['nginx']['dir'], 'certs', 'rubygems.org.key'),
    ssl_cert:     File.join(node['nginx']['dir'], 'certs', 'rubygems.org.crt'),
    fastly_ip_ranges: node['fastly_ip_ranges'],
    gem_mirror_ssl: "https://#{fastly_domain}.global.ssl.fastly.net",
    gem_mirror: "http://#{fastly_domain}.global.ssl.fastly.net"
  )
  notifies :reload, 'service[nginx]'
end

nginx_site 'rubygems'
