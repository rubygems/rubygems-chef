chef_gem 'chef-vault'

require 'chef-vault'

include_recipe 'rubygems'

duo = ChefVault::Item.load("duo", "credentials")

node.default['duosecurity']['ikey'] = duo['ikey']
node.default['duosecurity']['skey'] = duo['skey']
node.default['duosecurity']['host'] = duo['hostname']

include_recipe 'duo-security'
