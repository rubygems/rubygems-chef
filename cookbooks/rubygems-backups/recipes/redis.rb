#
# Cookbook Name:: rubygems-backups
# Recipe:: redis
#

include_recipe 'rubygems-backups::_common'

backup_secrets = chef_vault_item('secrets', 'backups')

template File.join(node['rubygems']['backups']['config_dir'], 'redis.rb') do
  source 'redis.rb.erb'
  owner 'root'
  group 'root'
  mode 00600
  variables(
    gpg_email: backup_secrets['gpg_email'],
    gpg_public_key: backup_secrets['gpg_public_key'],
    aws_access_key: backup_secrets['aws_access_key'],
    aws_secret_key: backup_secrets['aws_secret_key'],
    bucket_name: 'rubygems-backups',
    slack_token: backup_secrets['slack_token']
  )
end

cron 'redis-backup' do
  hour '23'
  minute '23'
  day '*'
  month '*'
  weekday '*'
  path '/usr/local/bin:/usr/bin:/bin'
  command "backup perform --trigger redis --config-file #{File.join(node['rubygems']['backups']['config_dir'], 'redis.rb')}"
  user 'root'
end
