#
# Cookbook Name:: rubygems-repo
# Recipe:: default
#

include_recipe 'rubygems'

node.default['aptly']['architectures'] = ['amd64']

# This repo contains scripts for snapshotting, merging, and publishing repos.
git "#{node['aptly']['rootdir']}/apt-tools" do
  repository 'https://github.com/skottler/rubygems-apt-tools' do
    revision 'master'
    checkout_branch 'master'
    action :sync
    user node['aptly']['user']
  end
end

include_recipe 'aptly'
include_recipe 'nginx'

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
