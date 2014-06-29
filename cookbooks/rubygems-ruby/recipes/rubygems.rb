#
# Cookbook Name:: rubygems-ruby
# Recipe:: rubygems
#

node.default['rubygems']['rubygems_version'] = '2.2.2'

execute "gem update --system #{node['rubygems']['rubygems_version']}" do
  action :run
  environment 'REALLY_GEM_UPDATE_SYSTEM' => 'true'
  not_if "gem -v | grep -q '#{node['rubygems']['rubygems_version']}'"
end
