cron 'chef-client' do
  minute  '*/15'
  hour    '*'
  user    'root'
  command '/usr/bin/chef-client'
end
