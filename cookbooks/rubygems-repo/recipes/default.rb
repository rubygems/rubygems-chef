#
# Cookbook Name:: rubygems-repo
# Recipe:: default
#

include_recipe 'rubygems'

node.default['aptly']['architectures'] = ['amd64']

# Dont' re-sign packages with our own key.
node.default['aptly']['gpgdisablesign'] = true

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
