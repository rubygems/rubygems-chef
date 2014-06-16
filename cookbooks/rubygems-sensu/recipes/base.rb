gem_package "sensu-plugin" do
  gem_binary "/opt/sensu/embedded/bin/gem"
end

package "nagios-plugins"

%w{ check-procs.rb }.each do |plugin|
  cookbook_file "/etc/sensu/plugins/#{plugin}" do
    source plugin
    path "/etc/sensu/plugins/#{plugin}"
    owner "sensu"
    group "sensu"
    mode "0755"
    action :create
  end
end

sensu_check "check_procs" do
  command "/opt/sensu/embedded/bin/ruby /etc/sensu/plugins/check-procs.rb"
  handlers ["default"]
  subscribers ["all"]
  interval 30
  additional(:notification => 'There is a high number of procs running', :occurences => 3)
end

sensu_check "check_ssh" do
  command "/usr/lib/nagios/plugins/check_ssh localhost"
  handlers ["default"]
  subscribers ["all"]
  interval 30
  additional(:notification => 'sshd is not running', :occurences => 3)
end
