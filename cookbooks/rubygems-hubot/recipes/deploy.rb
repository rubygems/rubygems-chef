#
# Cookbook Name:: rubygems-hubot
# Recipe:: deploy
#

package 'libpq-dev'

directory node['rubygems-hubot']['deploy_dir'] do
  user 'hubot'
  group 'hubot'
end

git "#{node['rubygems-hubot']['deploy_dir']}/staging" do
  repository 'https://github.com/rubygems/rubygems.org.git'
  reference 'master'
  user node['hubot']['user']
  group node['hubot']['group']
  action :sync
  notifies :run, "execute[bundle_install_deploy]", :immediately
end

execute "bundle_install_deploy" do
  command "bundle install --local --deployment"
  cwd "#{node['rubygems-hubot']['deploy_dir']}/staging"
  user node['hubot']['user']
  group node['hubot']['group']
  action :nothing
end
