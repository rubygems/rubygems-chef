#
# Cookbook Name:: rubygems-ruby
# Recipe:: default
#

include_recipe 'apt'

apt_repository 'brightbox-ruby-ng' do
  uri          'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C3173AA6'
  notifies :run, 'execute[apt-get update]', :immediately
end

package 'ruby2.3'
package 'ruby2.3-dev'
package 'ruby-switch'

execute 'ruby-switch --set ruby2.3' do
  action :run
  not_if "ruby-switch --check | grep -q 'ruby2.3'"
end

gem_package 'bundler'
