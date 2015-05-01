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
