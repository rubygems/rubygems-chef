include_recipe 'ohai'

template "#{node['ohai']['plugin_path']}/vpc.rb" do
  source 'plugins/vpc.rb.erb'
  owner  'root'
  group  node['root_group']
  mode   '0755'
end