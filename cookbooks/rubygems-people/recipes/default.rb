#
# Cookbook Name:: rubygems-people
# Recipe:: default
#

include_recipe 'user'

meg_balancer_host = search('node', "roles:balancer AND chef_environment:#{node.chef_environment}")[0]['ipaddress'] rescue ''
meg_app_host = search('node', "roles:app AND chef_environment:#{node.chef_environment}").sort[0]['ipaddress'] rescue ''

users = data_bag('users')
sysadmins = []
valid_users = []
users.each do |user_name|
  user = data_bag_item('users', user_name)

  next unless user['environments'].include?(node.chef_environment)

  valid_users << user['username']
  sysadmins << user['username'] if user['admin']

  user_account user['username'] do
    comment   user['comment']
    password  user['password']
    ssh_keys  user['ssh_keys']
    shell     user['shell'] ? user['shell'] : '/bin/bash'
  end

  template "/home/#{user['username']}/.bashrc" do
    source 'bashrc.erb'
    owner user['username']
    group user['username']
    variables(
      environment: node.chef_environment,
      meg_balancer_host: meg_balancer_host,
      meg_app_host: meg_app_host
    )
  end
end

raise 'No valid users found, something might be wrong!' if valid_users.empty?
raise 'No valid admin users found, something might be wrong!' if sysadmins.empty?

# Other valid users
valid_users += ['deploy', 'ubuntu', 'nobody']

group 'sysadmin' do
  gid 2300
  members sysadmins
end

# Remove any invalid users
existing_users = File.read('/etc/passwd')
existing_users.each_line do |user|
  parts = user.split(':')
  uid = parts[2].to_i
  username = parts[0]
  comment = parts[4]
  if uid > 999 && !valid_users.include?(username)
    log "WARNING: Unauthorized user will be removed: #{username}" do
      level :warn
    end
    # user username do
    #   action :remove
    #   force true
    # end
  end
end

node.default['authorization']['sudo']['groups'] = ['sysadmin']
node.default['authorization']['sudo']['include_sudoers_d'] = true
node.default['authorization']['sudo']['passwordless'] = true
include_recipe 'sudo'

sudo 'deploy' do
  user      '%sysadmin'
  nopasswd  true
  commands  [
    '/usr/sbin/service unicorn restart',
    '/usr/sbin/service delayed_job restart',
    '/usr/bin/chef-client',
    '/bin/ln -s /etc/nginx/maintenance.html /var/www/rubygems/maintenance.html',
    '/bin/rm /var/www/rubygems/maintenance.html'
  ]
end

include_recipe 'rubygems-people::meg'
