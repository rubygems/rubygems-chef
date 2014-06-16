include_recipe 'chef-vault'

sensu_creds = ChefVault::Item.load("sensu", "credentials")

node.default['sensu']['use_ssl'] = false
node.default['sensu']['dashboard']['bind'] = '0.0.0.0'
node.default['sensu']['dashboard']['user'] = sensu_creds['user']
node.default['sensu']['dashboard']['password'] = sensu_creds['password']

%w{ irc }.each do |handler|
  sensu_handler handler do
    type "pipe"
    command "irc.rb"
    severities ["critical"]
  end

  cookbook_file "/etc/sensu/handlers/#{handler}.rb" do
    path "/etc/sensu/handlers/#{handler}.rb"
    source "#{handler}.rb"
    action :create
  end

  cookbook_file "/etc/sensu/#{handler}.json" do
    path "/etc/sensu/#{handler}.json"
    source "#{handler}.json"
    action :create
  end
end
   
include_recipe "rubygems-sensu::librato"

include_recipe "sensu::rabbitmq"
include_recipe "sensu::redis"
include_recipe "sensu::server_service"
include_recipe "sensu::api_service"
include_recipe "sensu::dashboard_service"
