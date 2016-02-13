define :auth_proxy, org: 'rubygems' do
  name = "auth_proxy_#{params[:name]}"

  node.default['nginx']['server_tokens'] = 'off'
  node.default['nginx']['default_site_enabled'] = false
  node.default['nginx']['repo_source'] = 'nginx'

  include_recipe 'rubygems-auth-proxy'
  include_recipe 'chef-vault'
  include_recipe 'nginx'
  include_recipe 'runit'

  runit_service name do
    cookbook 'rubygems-auth-proxy'
    run_template_name 'auth-proxy'
    default_logger true
    options(
      org: params[:org],
      team: params[:team],
      upstream_port: params[:upstream_port],
      client_id: params[:client_id],
      client_secret: params[:client_secret],
      cookie_secret: params[:cookie_secret]
    )
    restart_on_update ::File.exist?("/etc/sv/#{name}")
  end

  item = chef_vault_item('certs', 'production')

  directory "#{node['nginx']['dir']}/certs" do
    owner 'root'
    group 'root'
    mode  '0644'
  end

  file "#{node['nginx']['dir']}/certs/rubygems.org.key" do
    content item['key']
    owner  'root'
    group  'root'
    mode   '0644'
    notifies :reload, 'service[nginx]'
  end

  file "#{node['nginx']['dir']}/certs/rubygems.org.crt" do
    content item['crt']
    owner  'root'
    group  'root'
    mode   '0644'
    notifies :reload, 'service[nginx]'
  end

  template "#{node['nginx']['dir']}/sites-available/#{name}" do
    source 'nginx.conf.erb'
    cookbook 'rubygems-auth-proxy'
    owner  'root'
    group  'root'
    mode   '0644'
    variables(
      server_name: params[:server_name]
    )
    notifies :reload, 'service[nginx]'
  end

  nginx_site name
end
