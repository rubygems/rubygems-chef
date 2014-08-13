#
# Cookbook Name:: rubygems-ntp
# Recipe:: default
#

# Force this, because something else is changing it and the ntp cookbook relies on it
# https://github.com/gmiranda23/ntp/blob/582353887f7ce5ad716916edcf8568be23619ae4/templates/default/ntp.conf.erb#L6
node.set['virtualization']['role'] = 'guest'

include_recipe 'ntp'
