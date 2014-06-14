cron 'chef-client' do
  minute  '*/15'
  hour    '*'
  user    'root'
  command '/usr/bin/chef-client'
end

append_if_no_line "enable ssl verification when talking to the server" do
  path "/etc/chef/client.rb"
  line "ssl_verify_mode :verify_peer"
end
