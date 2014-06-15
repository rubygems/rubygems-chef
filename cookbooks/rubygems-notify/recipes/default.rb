node.default['chef_client']['handler']['irc']['channel'] = '#rubygems-aws'
node.default['chef_client']['handler']['irc']['hostname'] = 'irc.freenode.net'
node.default['chef_client']['handler']['irc']['join'] = true
node.default['chef_client']['handler']['irc']['nick'] = 'rubygems-chef'

include_recipe "irc_handler"
