#
# Cookbook Name:: rubygems-app
# Recipe:: config
#

include_recipe 'chef-vault'

dbhost = data_bag_item('hosts', 'database')['environments'][node.chef_environment]

secrets = chef_vault_item('rubygems', node.chef_environment)
db_host = search(:node, "name:#{dbhost}.#{node.chef_environment}.rubygems.org")[0]

template '/applications/rubygems/shared/config/database.yml' do
  source 'database.yml.erb'
  owner 'deploy'
  group 'deploy'
  mode '0644'
  variables(
    rails_env: node.chef_environment,
    adapter: 'postgresql',
    database: "rubygems_#{node.chef_environment}",
    username: secrets['rails_postgresql_user'],
    password: db_host['postgresql']['password']['postgres'],
    host: db_host['ipaddress']
  )
end

fastly_domain = node.chef_environment == 'production' ? 'rubygems' : 'rubygems-staging'
fastly_log_processor_enabled = node.chef_environment == 'production' ? false : true

template '/applications/rubygems/shared/config/secret.rb' do
  source 'secret.rb.erb'
  owner  'deploy'
  group  'deploy'
  mode   '0640'
  action :create
  variables(
    s3_key: secrets['s3_key'],
    s3_secret: secrets['s3_secret'],
    aws_region: secrets['stats_aws_region'],
    fastly_log_processor_enabled: fastly_log_processor_enabled,
    secret_key_base: secrets['secret_key_base'],
    bundler_token: secrets['bundler_token'],
    bundler_api_url: secrets['bundler_api_url'],
    new_relic_license_key: secrets['new_relic_license_key'],
    new_relic_app_name: "RubyGems.org (#{node.chef_environment})",
    fastly_api_key: secrets['fastly_api_key'],
    fastly_service_id: secrets['fastly_service_id'],
    fastly_domain: "#{fastly_domain}.global.ssl.fastly.net",
    elasticsearch_url: secrets['elasticsearch_url'],
    memcached_endpoint: secrets['memcached_endpoint'],
    honeybadger_api_key: secrets['honeybadger_api_key']
  )
end
