#
# Cookbook Name:: rubygems-motd
# Recipe:: default
#

%w{ 00-header  10-help-text  50-landscape-sysinfo  51-cloudguest }.each do |item|
  motd item do
    action :delete
  end
end

motd '50-rubygems' do
  cookbook 'rubygems-motd'
  source '50-rubygems.erb'
end
