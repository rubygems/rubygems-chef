#
# Cookbook Name:: rubygems-hubot
# Recipe:: default
#

include_recipe 'chef-vault'
slack_secrets = chef_vault_item('slack', 'hubot')

node.set['hubot']['version'] = '2.4.6'
node.set['hubot']['scripts_version'] = '2.4.1'
node.set['hubot']['install_dir'] = '/srv/hubot'
node.set['hubot']['adapter'] = 'slack'

node.set['hubot']['dependencies'] = {
  'hubot-slack' => '2.1.0',
  'hubot-chef' => '>= 0.0.0',
  'hubot-capistrano' => '1.0.2'
}

node.set['hubot']['hubot_scripts'] = %w(
  ascii.coffee
  base64.coffee
  beerme.coffee
  gemwhois.coffee
  github-status.coffee
  goooood.coffee
  haters.coffee
  kittens.coffee
  likeaboss.coffee
  look-of-disapproval.coffee
  nice.coffee
  rubygems.coffee
  shipit.coffee
  sudo.coffee
  wunderground.coffee
  xkcd.coffee
)

node.set['hubot']['external_scripts'] = %w(
  hubot-chef
  hubot-capistrano
)

directory '/var/lib/hubot-capistrano'

node.set['hubot']['config'] = {
  'HUBOT_SLACK_TOKEN' => slack_secrets['token'],
  'HUBOT_SLACK_TEAM' => 'rubygems',
  'HUBOT_SLACK_BOTNAME' => 'hubot',
  'HUBOT_CAP_DIR' => '/var/lib/hubot-capistrano'
}

include_recipe 'hubot'

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

include_recipe 'rsyslog'

template '/etc/rsyslog.d/30-hubot.conf' do
  source 'rsyslog.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
  notifies :restart, 'service[rsyslog]'
end

template '/etc/logrotate.d/hubot' do
  source 'logrotate.erb'
  owner 'root'
  group 'root'
  mode '644'
end
