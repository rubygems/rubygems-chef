#
# Cookbook Name:: rubygems-ruby
# Recipe:: default
#

%w( ruby2.0 ruby2.0-dev ).each do |pkg|
  package pkg
end

link '/usr/bin/ruby' do
  to  '/usr/bin/ruby2.0'
end

link '/usr/bin/gem' do
  to '/usr/bin/gem2.0'
end

gem_package 'bundler'
