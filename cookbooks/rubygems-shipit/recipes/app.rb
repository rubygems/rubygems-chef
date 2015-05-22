#
# Cookbook Name:: rubygems-shipit
# Recipe:: app
#

current_environment = 'production'
current_app_path = '/applications/shipit/current'

if File.directory? current_app_path

  1.times do |n|
    the_port = 3000 + n
    service_name = "shipit-thin-#{the_port}"

    runit_service service_name do
      run_template_name 'thin'
      default_logger true
      options(
        deploy_path: current_app_path,
        run_as_user: 'shipit',
        listen_ip: '127.0.0.1',
        listen_port: the_port,
        bundle_bin: '/usr/local/bin/bundle',
        rack_env: current_environment,
        timeout: 30
      )
      restart_on_update ::File.exist?("/etc/sv/#{service_name}")
    end
  end

  1.times do |n|
    worker_name = "shipit-resque-#{n+1}"

    runit_service worker_name do
      run_template_name 'resque'
      default_logger true
      restart_on_update false
      options(
        path: current_app_path,
        user: 'shipit',
        queue: 'deploys,default,*',
        worker_name: worker_name,
        num_workers: 1
      )
    end
  end

else
  Chef::Log.error('You need to deploy the application before we can set up the application servers.')
end
