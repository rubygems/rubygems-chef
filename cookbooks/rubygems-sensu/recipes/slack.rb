#
# Cookbook Name:: rubygems-sensu
# Recipe:: slack
#

include_recipe 'chef-vault'

# These have to be different than the handler credentials because Slack
# provides a separate token for each integration.
slack_creds = chef_vault_item('sensu', 'credentials')['slack']

template '/etc/sensu/conf.d/slack.json' do
  source 'slack.json.erb'
  owner 'sensu'
  group 'sensu'
  variables(
    token: slack_creds['token'],
    team_name: slack_creds['team_name'],
    channel: slack_creds['channel']
  )
end

cookbook_file '/etc/sensu/handlers/slack.rb' do
  path '/etc/sensu/handlers/slack.rb'
  source 'slack.rb'
  mode '0755'
  action :create
end

sensu_handler 'slack' do
  type 'pipe'
  command 'slack.rb'
  severities ['ok', 'critical']
end
