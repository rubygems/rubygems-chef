#
# Cookbook Name:: rubygems-logging
# Recipe:: server_kibana
#

node.default['kibana']['version'] = '4.0.2-linux-x64'
node.default['kibana']['file']['url'] = 'https://download.elasticsearch.org/kibana/kibana/kibana-4.0.2-linux-x64.tar.gz'
include_recipe 'kibana_lwrp'

kibana_user node['kibana']['user'] do
  name node['kibana']['user']
  group node['kibana']['user']
  home node['kibana']['install_dir']
  action :create
end

kibana_install 'kibana' do
  user node['kibana']['user']
  group node['kibana']['user']
  install_dir node['kibana']['install_dir']
  install_type node['kibana']['install_type']
  action :create
end

kibana_config = "#{node['kibana']['install_dir']}/current/#{node['kibana'][node['kibana']['install_type']]['config']}"
es_server = "#{node['kibana']['es_scheme']}#{node['kibana']['es_server']}:#{node['kibana']['es_port']}"

template kibana_config do
  source node['kibana'][node['kibana']['install_type']]['config_template']
  cookbook node['kibana'][node['kibana']['install_type']]['config_template_cookbook']
  mode '0644'
  user node['kibana']['user']
  group node['kibana']['user']
  variables(
    index: node['kibana']['config']['kibana_index'],
    port: node['kibana']['java_webserver_port'],
    elasticsearch: es_server,
    default_route: node['kibana']['config']['default_route'],
    panel_names:  node['kibana']['config']['panel_names']
  )
end

runit_service 'kibana' do
  options(
    user: node['kibana']['user'],
    home: "#{node['kibana']['install_dir']}/current"
  )
  cookbook 'kibana_lwrp'
  subscribes :restart, "template[#{kibana_config}]", :delayed
end
