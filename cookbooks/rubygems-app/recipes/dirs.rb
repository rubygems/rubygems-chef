#
# Cookbook Name:: rubygems-app
# Recipe:: dirs
#

directory '/applications' do
  owner  'deploy'
  group  'deploy'
end

directory '/applications/rubygems' do
  owner  'deploy'
  group  'deploy'
  mode   '0775'
end

directory '/applications/rubygems/releases' do
  owner  'deploy'
  group  'deploy'
  mode   '0775'
end

directory '/applications/rubygems/shared' do
  owner  'deploy'
  group  'deploy'
  mode   '0775'
end

directory '/applications/rubygems/shared/log' do
  owner  'deploy'
  group  'deploy'
  mode   '0775'
end
