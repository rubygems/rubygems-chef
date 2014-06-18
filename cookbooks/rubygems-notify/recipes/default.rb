#
# Cookbook Name:: rubygems-notify
# Recipe:: default
#

include_recipe 'chef-vault'

slack_creds = ChefVault::Item.load('slack', 'credentials')

node.default['chef_client']['handler']['slack']['team'] = slack_creds['team']
node.default['chef_client']['handler']['slack']['api_key'] = slack_creds['api_key']
node.default['chef_client']['handler']['slack']['channel'] = slack_creds['channel']
node.default['chef_client']['handler']['slack']['username'] = slack_creds['username']
node.default['chef_client']['handler']['slack']['icon_url'] = slack_creds['icon_url']

include_recipe 'slack_handler'
