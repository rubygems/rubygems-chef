#
# Cookbook Name:: rubygems-auth-proxy
# Recipe:: default
#

ark 'oauth2_proxy' do
  url 'https://github.com/bitly/oauth2_proxy/releases/download/v2.0.1/oauth2_proxy-2.0.1.linux-amd64.go1.4.2.tar.gz'
  version '2.0.1'
  checksum 'c6d8f6d74e1958ce1688f3cf7d60648b9d0d6d4344d74c740c515a00b4e023ad'
  has_binaries ['oauth2_proxy']
end
