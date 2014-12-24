#
# Cookbook Name:: rubygems-hubot
# Recipe:: ssh
#

include_recipe 'chef-vault'
hubot_secrets = chef_vault_item('hubot', 'keys')

directory "#{node['hubot']['install_dir']}/.ssh" do
  owner node['hubot']['user']
  mode 0700
end

file "#{node['hubot']['install_dir']}/.ssh/id_rsa" do
  owner node['hubot']['user']
  mode 0600
  content hubot_secrets['private']
end

file "#{node['hubot']['install_dir']}/.ssh/id_rsa.pub" do
  owner node['hubot']['user']
  content hubot_secrets['public']
end
