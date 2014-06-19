# These have to be different than the handler credentials because Slack
# provides a separate token for each integration.
slack_creds = ChefVault::Item.load('sensu', 'credentials')['slack']

template '/etc/sensu/slack.json' do
  source 'slack.json.erb'
  path '/etc/sensu/slack.json'
  owner 'sensu'
  group 'sensu'
  variables(
    token: slack_creds['token'],
    team_name: slack_creds['team_name']
  )
end

cookbook_file '/etc/sensu/handlers/sensu.rb' do
  path '/etc/sensu/handlers/sensu.rb'
  source 'sensu.rb'
  action :create
end

sensu_handler 'slack' do
  type 'pipe'
  command 'slack.rb'
  severities ['ok', 'critical']
end
