#
# Cookbook Name:: rubygems-balancer
# Recipe:: logging
#

log_fields = {
  'host' => node.name,
  '@timestamp' => '$time_iso8601',
  'status' => '$status',
  'scheme' => '$scheme',
  'uri' => '$request_uri',
  'args' => '$args',
  'dest_host' => '$http_host',
  'content_type' => '$sent_http_content_type',
  'protocol' => '$server_protocol',
  'referer' => '$http_referer',
  'user_agent' => '$http_user_agent',
  'client_ip' => '$remote_addr',
  'remote_user' => '$remote_user',
  'body_bytes' => '$body_bytes_sent',
  'upstream_x_runtime' => '$upstream_http_x_runtime',
  'processing_time' => '$request_time',
  'upstream_processing_time' => '$upstream_response_time',
  'method' => '$request_method',
  'request' => '$request',
  'request_id' => '$upstream_http_x_request_id',
  'upstream' => '$upstream_addr',
  'ssl_protocol' => '$ssl_protocol',
  'ssl_cipher' => '$ssl_cipher'
}

template "#{node['nginx']['dir']}/conf.d/logging.conf" do
  source 'logging.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(log_format: log_fields)
  notifies :reload, 'service[nginx]'
end
