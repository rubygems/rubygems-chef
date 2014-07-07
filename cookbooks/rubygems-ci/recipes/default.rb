#
# Cookbook Name:: rubygems-ci
# Recipe:: default
#

include_recipe 'rubygems'

# TODO: remove these three attributes once https://issues.jenkins-ci.org/browse/JENKINS-22346
# is fixed.
node.default['jenkins']['master']['install_method'] = 'war'
node.default['jenkins']['master']['version'] = '1.555'
node.default['jenkins']['master']['source'] = "#{node['jenkins']['master']['mirror']}/war/#{node['jenkins']['master']['version']}/jenkins.war"

include_recipe 'jenkins::java'
include_recipe 'jenkins::master'

include_recipe 'rubygems-ci::dns'
include_recipe 'rubygems-ci::nginx'

plugins = data_bag_item('jenkins', 'plugins')['plugins']

plugins.each do |plugin|
  jenkins_plugin plugin do
    action :install
  end
end
