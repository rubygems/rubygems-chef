#
# Cookbook Name:: rubygems-chef
# Recipe:: slack
#

include_recipe 'chef-vault'
slack_creds = chef_vault_item('slack', 'credentials')

directory '/etc/chef/client.d'

chef_gem 'slackr'

template '/etc/chef/client.d/slack.rb' do
  source 'slack.rb'
  mode '0644'
  variables(
    team: slack_creds['team'],
    api_key: slack_creds['api_key'],
    channel: slack_creds['channel'],
    username: slack_creds['username'],
    icon_url: slack_creds['icon_url']
  )
end
