#
# Cookbook Name:: rubygems-repo
# Recipe:: default
#

include_recipe 'rubygems'

node.default['aptly']['architectures'] = ['amd64']

include_recipe 'aptly'

# This repo contains scripts for snapshotting, merging, and publishing repos.
git "#{node['aptly']['rootdir']}/apt-tools" do
  repository 'https://github.com/rubygems/apt-tools'
  revision 'master'
  action :sync
  user node['aptly']['user']
end

aptly_mirror 'ubuntu-trusty-main' do
  action :create
  distribution 'trusty'
  component 'main'
  keyid 'C0B21F32'
  keyserver 'keys.gnupg.net'
  uri 'http://ubuntu.osuosl.org/ubuntu/'
end

aptly_mirror 'ubuntu-trusty-universe' do
  action :create
  distribution 'trusty'
  component 'universe'
  keyid 'C0B21F32'
  keyserver 'keys.gnupg.net'
  uri 'http://ubuntu.osuosl.org/ubuntu/'
end

aptly_mirror 'ubuntu-trusty-security-main' do
  action :create
  distribution 'trusty-security'
  component 'main'
  keyid 'C0B21F32'
  keyserver 'keys.gnupg.net'
  uri 'http://ubuntu.osuosl.org/ubuntu/'
end

aptly_mirror 'ubuntu-trusty-updates-main' do
  action :create
  distribution 'trusty-updates'
  component 'main'
  keyid 'C0B21F32'
  keyserver 'keys.gnupg.net'
  uri 'http://ubuntu.osuosl.org/ubuntu/'
end

aptly_mirror 'sensu' do
  action :create
  distribution 'sensu'
  component 'main'
  uri 'http://repos.sensuapp.org/apt'
end

include_recipe 'nginx'
include_recipe 'rubygems-repo::nginx'

link "#{node['aptly']['rootdir']}/public/packages.key" do
  to '/var/apt/rubygems/packages.key'
end
