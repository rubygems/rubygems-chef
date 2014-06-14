chef_username = ENV['RUBYGEMS_CHEF_USERNAME'] || ENV['USER']
current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT
node_name                chef_username
client_key               "#{current_dir}/#{chef_username}.pem"
validation_client_name   "rubygems-validator"
validation_key           "#{current_dir}/rubygems-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/rubygems"

# Provision new instances with knife-ec2
knife[:aws_access_key_id] = ENV['RUBYGEMS_AWS_ACCESS_KEY_ID']
knife[:aws_secret_access_key] = ENV['RUBYGEMS_AWS_SECRET_KEY_ID']
