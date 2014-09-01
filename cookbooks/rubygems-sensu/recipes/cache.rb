include_recipe 'build-essential'
include_recipe 'cpan'

cpan_client 'Cache::Memcached' do
  user 'root'
  group 'root'
  force true
  install_type 'cpan_module'
  action 'install'
end

cpan_client 'String::CRC32' do
  user 'root'
  group 'root'
  force true
  install_type 'cpan_module'
  action 'install'
end
