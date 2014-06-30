# We use /etc/apt/sources.list.d/ for everything.
file '/etc/apt/sources.list' do
  action :delete
end

file '/etc/apt/apt.conf.d/05unauthenticated' do
  action :create
  content "APT::Get::AllowUnauthenticated 'true';"
end

apt_repository 'rubygems_main' do
  uri 'http://repo01.common.rubygems.org'
  distribution node['lsb']['codename']
  components ['main']
end
