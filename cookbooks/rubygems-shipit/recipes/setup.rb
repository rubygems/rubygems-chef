#
# Cookbook Name:: rubygems-shipit
# Recipe:: setup
#

BASE_DIR      = '/applications/shipit'.freeze
SSH_DIR       = "#{BASE_DIR}/.ssh".freeze
SHARED_DIR    = "#{BASE_DIR}/shared".freeze
BUNDLE_PATH   = "#{BASE_DIR}/shared/bundle".freeze
DATA_DIR      = "#{BASE_DIR}/shared/data".freeze
LOG_DIR       = "#{BASE_DIR}/shared/log".freeze
ASSET_DIR     = "#{BASE_DIR}/shared/public/assets".freeze

user 'shipit' do
  system true
  home BASE_DIR
end

extra_dirs = [
  [BASE_DIR,               '0755', 'deploy', 'users'],
  [SSH_DIR,                '0755', 'shipit', 'shipit'],
  [SHARED_DIR,             '0755', 'deploy', 'users'],
  [BUNDLE_PATH,            '0775', 'deploy', 'users'],
  [DATA_DIR,               '0770', 'shipit', 'shipit'],
  [LOG_DIR,                '0755', 'shipit', 'shipit'],
  ["#{BASE_DIR}/.heroku",  '0755', 'shipit', 'shipit'],
  ["#{SHARED_DIR}/public", '0755', 'shipit', 'shipit'],
  ["#{SHARED_DIR}/config", '0755', 'shipit', 'shipit'],
  [ASSET_DIR,              '0755', 'deploy', 'users'],
  ['/tmp/shipit',          '0755', 'deploy', 'users'],
  ["#{SHARED_DIR}/public/system", '0755', 'deploy', 'users']
]

extra_dirs.each do |full_path, permissions, user, group|
  directory full_path do
    owner user
    group group
    mode permissions
  end
end

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode '0600'
end

bag = chef_vault_item('apps', 'shipit')

file "#{SSH_DIR}/id_rsa" do
  owner 'shipit'
  group 'shipit'
  mode '0600'
  content bag['key']['private']
end

current_environment = 'production'
raw_yaml_files      = %w(database)
shared_config_path  = "#{BASE_DIR}/shared/config"

raw_yaml_files.each do |name|
  data = { current_environment => bag[name] }
  file "#{shared_config_path}/#{name}.yml" do
    owner 'deploy'
    group 'shipit'
    mode '0640'
    content JSON(data.to_json).to_yaml
  end
end

template "#{shared_config_path}/secrets.yml" do
  owner 'deploy'
  group 'shipit'
  mode '0640'
  variables(
    bag['secrets']['production'].merge(
      hostname: 'https://shipit.rubygems.org',
      home_dir: BASE_DIR,
      auth_keys: bag['auth_keys']
    )
  )
end

template "#{BASE_DIR}/.netrc" do
  owner    'shipit'
  group    'shipit'
  mode     '0600'
  source   'shipit-netrc.erb'
  variables(
    netrc: bag['netrc']
  )
end

logrotate_app 'shipit' do
  options    %w(missingok notifempty compress delaycompress)
  path       ["#{LOG_DIR}/*.log"]
  frequency  'daily'
  rotate     4
  postrotate 'sv hup /etc/sv/shipit-thin-* && sv quit /etc/sv/shipit-resque-*'
end

sudo 'deploy-shipit-thin' do
  user 'deploy'
  commands [
    '/etc/init.d/shipit-thin-* *',
    '/usr/sbin/service shipit-thin-* *',
    '/usr/bin/sv * /etc/sv/shipit-thin-*'
  ]
  nopasswd true
end

sudo 'deploy-shipit-resque' do
  user 'deploy'
  commands [
    '/etc/init.d/shipit-resque-* *',
    '/usr/sbin/service shipit-resque-* *',
    '/usr/bin/sv * /etc/sv/shipit-resque-*'
  ]
  nopasswd true
end
