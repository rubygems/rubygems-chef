#
# Cookbook Name:: rubygems-people
# Recipe:: deploy
#

include_recipe 'user'

users = data_bag('users')
keys = []

users.each do |user_name|
  user = data_bag_item('users', user_name)
  user['ssh_keys'].each { |k| keys << k } if user['deployer'] == true && user['environments'].include?(node.chef_environment)
end

keys << chef_vault_item('apps', 'shipit')['key']['public']

user_account 'deploy' do
  comment   'Application Deployment'
  password  '$1$OghAZXA4$agFSQnk5/bJVs8rA8SaSh2'
  ssh_keys  keys
end
