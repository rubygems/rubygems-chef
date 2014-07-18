#
# Cookbook Name:: rubygems-bastion
# Recipe:: meg
#

git '/opt/meg' do
  repository 'https://github.com/rubygems/meg'
  reference 'chef'
  action :sync
end

link '/usr/bin/meg' do
  to '/opt/meg/bin/meg'
end
