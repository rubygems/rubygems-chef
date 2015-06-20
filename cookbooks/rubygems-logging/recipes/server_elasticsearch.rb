#
# Cookbook Name:: rubygems-logging
# Recipe:: server_elaticsearch
#

aws_credentials = chef_vault_item('aws', 'credentials')
node.default['elasticsearch']['cloud']['aws']['access_key'] = aws_credentials['access_key_id']
node.default['elasticsearch']['cloud']['aws']['secret_key'] = aws_credentials['secret_access_key']
node.default['elasticsearch']['cloud']['aws']['region'] = 'us-west-2'
node.default['elasticsearch']['version'] = '1.5.0'
node.default['elasticsearch']['allocated_memory'] = '4000m'
node.default['elasticsearch']['bootstrap']['mlockall'] = true

# node.default['elasticsearch']['custom_config']['threadpool.search.type'] = 'fixed'
# node.default['elasticsearch']['custom_config']['threadpool.search.size'] = '20'
# node.default['elasticsearch']['custom_config']['threadpool.search.queue_size'] = '100'

node.default['elasticsearch']['custom_config']['threadpool.bulk.type'] = 'fixed'
node.default['elasticsearch']['custom_config']['threadpool.bulk.size'] = '60'
node.default['elasticsearch']['custom_config']['threadpool.bulk.queue_size'] = '300'

node.default['elasticsearch']['custom_config']['threadpool.index.type'] = 'fixed'
node.default['elasticsearch']['custom_config']['threadpool.index.size'] = '20'
node.default['elasticsearch']['custom_config']['threadpool.index.queue_size'] = '100'

node.default['elasticsearch']['custom_config']['indices.memory.index_buffer_size'] = '30%'
node.default['elasticsearch']['custom_config']['indices.memory.min_shard_index_buffer_size'] = '12mb'
node.default['elasticsearch']['custom_config']['indices.memory.min_index_buffer_size'] = '96mb'

node.default['elasticsearch']['custom_config']['indices.fielddata.cache.size'] = '15%'
node.default['elasticsearch']['custom_config']['indices.fielddata.cache.expire'] = '6h'
node.default['elasticsearch']['custom_config']['indices.cache.filter.size'] = '15%'
node.default['elasticsearch']['custom_config']['indices.cache.filter.expire'] = '6h'

node.default['elasticsearch']['custom_config']['index.refresh_interval'] = '30s'
node.default['elasticsearch']['custom_config']['index.translog.flush_threshold_ops'] = '50000'

node.default['elasticsearch']['gc_settings'] =<<-CONFIG
  -XX:+UseG1GC
  -XX:+HeapDumpOnOutOfMemoryError
CONFIG

node.default['elasticsearch']['path']['data'] = ['/data/elasticsearch/disk1', '/data/elasticsearch/disk2']
node.default['elasticsearch']['data']['devices'] = {
  '/dev/xvdf' => {
    'file_system'      => 'ext4',
    'mount_options'    => 'rw',
    'mount_path'       => '/data/elasticsearch/disk1',
    'format_command'   => 'mkfs.ext4 -F',
    'fs_check_command' => 'dumpe2fs',
    'ebs'              => {
      'size' => 500,
      'device' => '/dev/sdf',
      'delete_on_termination' => true,
      'type' => 'io1',
      'iops' => 2000
    }
  },
  '/dev/xvdg' => {
    'file_system'      => 'ext4',
    'mount_options'    => 'rw',
    'mount_path'       => '/data/elasticsearch/disk2',
    'format_command'   => 'mkfs.ext4 -F',
    'fs_check_command' => 'dumpe2fs',
    'ebs'              => {
      'size' => 500,
      'device' => '/dev/sdg',
      'delete_on_termination' => true,
      'type' => 'io1',
      'iops' => 2000
    }
  }
}

include_recipe 'elasticsearch'
include_recipe 'elasticsearch::ebs'
include_recipe 'elasticsearch::data'

install_plugin 'lmenezes/elasticsearch-kopf'

easy_install_package 'elasticsearch-curator'

cron_d 'delete_old_logstash_indexes' do
  user 'root'
  action :create
  hour '9'
  minute '0'
  command "/usr/local/bin/curator delete indices --older-than 30 --time-unit days --prefix logstash- --timestring '\\%Y.\\%m.\\%d'"
end
