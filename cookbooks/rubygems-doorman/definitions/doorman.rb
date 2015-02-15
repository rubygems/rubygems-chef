define :doorman do

  node.default['nodejs']['install_method'] = 'package'
  include_recipe 'nodejs'

  user 'doorman' do
    home '/applications/doorman'
    system true
    shell '/bin/false'
  end

  group 'doorman' do
    members 'doorman'
  end

  directory '/applications/doorman' do
    owner 'doorman'
    group 'doorman'
  end

  git '/applications/doorman' do
    repository 'https://github.com/movableink/doorman.git'
    reference '2fdae663107a45d485e52a298499fac89722db18'
    user 'doorman'
    group 'doorman'
    action :sync
    notifies :run, 'execute[doorman_npm_install]', :immediately
  end

  execute 'doorman_npm_install' do
    command 'npm install'
    cwd '/applications/doorman'
    environment(
      'USER' => 'doorman',
      'HOME' => '/applications/doorman'
    )
    action :nothing
    notifies :restart, 'service[doorman]', :delayed
  end

  template '/applications/doorman/conf.js' do
    source 'doorman-conf.js.erb'
    owner 'doorman'
    group 'doorman'
    mode '0644'
    variables(
      session_cookie_secret: secrets['session_cookie_secret'],
      github_app_id: secrets['github_app_id'],
      github_app_secret: secrets['github_app_secret']
    )
  end

  include_recipe 'runit'

  runit_service 'doorman' do
    owner 'doorman'
    group 'doorman'
    default_logger true
    options(
      owner: 'doorman',
      group: 'doorman'
    )
  end

end
