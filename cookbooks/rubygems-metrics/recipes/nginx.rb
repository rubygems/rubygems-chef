#
# Cookbook Name:: rubygems-metrics
# Recipe:: nginx
#

node.default['datadog']['nginx']['instances'] = [
  {
    'nginx_status_url' => 'http://localhost/nginx_status/',
    'tags' => []
  }
]

include_recipe 'datadog::nginx'
