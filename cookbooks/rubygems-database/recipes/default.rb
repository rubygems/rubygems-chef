include_recipe 'rubygems'

include_recipe 'postgresql::server'
include_recipe 'postgresql::ruby'

stage = node.chef_environment

connection_info =  {
  :host => '127.0.0.1'
  :port => 5432,
  :username => "postgres",
  :password => ""
}

postgresql_database "rubygems_#{stage}" do
  connection(connection_info)
  action :create
end

postgresql_database_user "rubygems_#{stage}" do
  connection(connection_info)
  password ""
  action :create
end
