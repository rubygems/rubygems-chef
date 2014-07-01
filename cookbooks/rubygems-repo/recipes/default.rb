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
