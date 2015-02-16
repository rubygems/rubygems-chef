#
# Cookbook Name:: rubygems-hubot
# Recipe:: default
#

include_recipe 'rubygems-ruby'

include_recipe 'chef-vault'
slack_secrets = chef_vault_item('slack', 'hubot')
hubot_secrets = chef_vault_item('hubot', 'credentials')

node.set['hubot']['version'] = '2.11.0'
node.set['hubot']['scripts_version'] = '2.5.16'
node.set['hubot']['install_dir'] = '/srv/hubot'
node.set['hubot']['adapter'] = 'slack'

node.set['hubot']['dependencies'] = {
  'hubot-slack' => '~3.1.0',
  'hubot-tweeter' => '~0.3.1',
  'async' => '^0.9.0'
}

node.set['hubot']['hubot_scripts'] = []

node.set['hubot']['external_scripts'] = ['hubot-tweeter']

node.set['hubot']['config'] = {
  'HUBOT_SLACK_TOKEN' => slack_secrets['token'],
  'HUBOT_SLACK_TEAM' => 'bundler',
  'HUBOT_SLACK_BOTNAME' => 'hubot',
  'HUBOT_TWITTER_CONSUMER_KEY' => hubot_secrets['twitter_consumer_key'],
  'HUBOT_TWITTER_CONSUMER_SECRET' => hubot_secrets['twitter_consumer_secret'],
  'HUBOT_TWEETER_ACCOUNTS' => "{\"rubygems_status\":{\"access_token\":\"#{hubot_secrets['twitter_access_token']}\",\"access_token_secret\":\"#{hubot_secrets['twitter_access_token_secret']}\"}}",
  'HUBOT_DEPLOY_DIR' => "#{node['rubygems-hubot']['deploy_dir']}/staging",
  'HUBOT_DEPLOY_LOG_DIR' => '/var/log/hubot_deploys'
}

template "#{node['hubot']['install_dir']}/external-scripts.json" do
  source 'hubot-scripts.json.erb'
  cookbook 'hubot'
  owner node['hubot']['user']
  group node['hubot']['group']
  mode 0644
  variables(hubot_scripts: node['hubot']['external_scripts'])
  notifies :restart, 'service[hubot]', :delayed
end

include_recipe 'hubot'

%w(math.coffee pugme.coffee rules.coffee translate.coffee google-images.coffee maps.coffee roles.coffee youtube.coffee).each do |filename|
  file "#{node['hubot']['install_dir']}/scripts/#{filename}" do
    action :delete
  end
end

remote_directory "#{node['hubot']['install_dir']}/scripts" do
  source 'scripts'
  files_backup 0
  files_owner node['hubot']['user']
  files_group node['hubot']['group']
  files_mode 00644
  owner node['hubot']['user']
  group node['hubot']['group']
  overwrite true
  mode 00755
  notifies :restart, 'service[hubot]'
end

# include_recipe 'rsyslog'

# template '/etc/rsyslog.d/30-hubot.conf' do
#   source 'rsyslog.conf.erb'
#   owner 'root'
#   group 'root'
#   mode '644'
#   notifies :restart, 'service[rsyslog]'
# end

# template '/etc/logrotate.d/hubot' do
#   source 'logrotate.erb'
#   owner 'root'
#   group 'root'
#   mode '644'
# end

include_recipe 'rubygems-hubot::ssh'
include_recipe 'rubygems-hubot::deploy'
include_recipe 'rubygems-hubot::doorman'
include_recipe 'rubygems-hubot::nginx'
