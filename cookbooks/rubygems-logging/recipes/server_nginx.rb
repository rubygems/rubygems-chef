#
# Cookbook Name:: rubygems-logging
# Recipe:: server_nginx
#

bag = chef_vault_item('apps', 'kibana')

auth_proxy 'logging' do
  org 'rubygems'
  team 'infrastructure'
  upstream_port 5601
  server_name 'logs.rubygems.org'
  client_id bag['client_id']
  client_secret bag['client_secret']
  cookie_secret bag['cookie_secret']
end
