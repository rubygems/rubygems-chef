#
# Cookbook Name:: rubygems-app
# Recipe:: deploy_user
#

include_recipe 'user'

user = data_bag_item('users', 'deploy')

user_account user['username'] do
  comment   user['comment']
  password  user['password']
  ssh_keys  user['ssh_keys']
end
