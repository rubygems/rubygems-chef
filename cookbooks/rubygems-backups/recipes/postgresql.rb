#
# Cookbook Name:: rubygems-backups
# Recipe:: postgresql
#

include_recipe 'rubygems-backups::_common'

secrets = chef_vault_item('rubygems', node.chef_environment)
backup_secrets = chef_vault_item('secrets', 'backups')

template File.join(node['rubygems']['backups']['config_dir'], 'postgresql.rb') do
  source 'postgresql.rb.erb'
  owner 'root'
  group 'root'
  mode 00600
  variables(
    postgresql_db: "rubygems_#{node.chef_environment}",
    postgresql_user: secrets['rails_postgresql_user'],
    postgresql_password: node['postgresql']['password']['postgres'],
    gpg_email: backup_secrets['gpg_email'],
    gpg_public_key: backup_secrets['gpg_public_key'],
    aws_access_key: backup_secrets['aws_access_key'],
    aws_secret_key: backup_secrets['aws_secret_key'],
    bucket_name: 'rubygems-backups',
    slack_token: backup_secrets['slack_token']
  )
end

cron 'postgresql-backup' do
  hour '22'
  minute '22'
  day '*'
  month '*'
  weekday '*'
  path '/usr/local/bin:/usr/bin:/bin'
  command "backup perform --trigger postgresql --config-file #{File.join(node['rubygems']['backups']['config_dir'], 'postgresql.rb')}"
  user 'root'
end

template File.join(node['rubygems']['backups']['config_dir'], 'public_postgresql.rb') do
  source 'public_postgresql.rb.erb'
  owner 'root'
  group 'root'
  mode 00600
  variables(
    postgresql_db: "rubygems_#{node.chef_environment}",
    postgresql_user: secrets['rails_postgresql_user'],
    postgresql_password: node['postgresql']['password']['postgres'],
    aws_access_key: backup_secrets['aws_access_key'],
    aws_secret_key: backup_secrets['aws_secret_key'],
    bucket_name: 'rubygems-dumps',
    slack_token: backup_secrets['slack_token']
  )
end

cron 'postgresql-public-dump' do
  hour '21'
  minute '21'
  day '*'
  month '*'
  weekday '1'
  path '/usr/local/bin:/usr/bin:/bin'
  command "backup perform --trigger public_postgresql --config-file #{File.join(node['rubygems']['backups']['config_dir'], 'public_postgresql.rb')}"
  user 'root'
  only_if { node.chef_environment == 'production' }
end
