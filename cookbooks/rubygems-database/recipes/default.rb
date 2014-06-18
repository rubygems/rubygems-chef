include_recipe 'rubygems'

include_recipe "postgresql::server"

stage = node.chef_environment

connection_info =  {
  :host => search(:node, "name:app01.#{stage}.rubygems.org")[0]['ipaddress'],
  :port => 5432,
  :username => "rubygems_#{stage}",
  :password => ""
}

postgresql_database "rubygems_#{stage}" do
  connection(connection_info)
  action :create
end

postgresql_database_user "rubygems_#{stage}" do
  connection connection_info
  password ""
  action :create
end
