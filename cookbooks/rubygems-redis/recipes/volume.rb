#
# Cookbook Name:: rubygems-redis
# Recipe:: volume
#

if node['cloud'] && node['cloud']['provider'] == 'ec2'

  device_id = '/dev/xvdf'
  mount_point = '/var/lib/redis'

  package 'xfsprogs'

  creds = chef_vault_item('aws', 'credentials')
  include_recipe 'aws'

  aws_ebs_volume 'redis_data_volume' do
    aws_access_key creds['access_key_id']
    aws_secret_access_key creds['secret_access_key']
    size 100
    volume_type 'io1'
    piops 3000
    device device_id.gsub('xvd', 'sd')
    action [:create, :attach]
  end

  ruby_block 'wait_for_redis_data_volume' do
    block do
      loop do
        if File.blockdev?(device_id)
          break
        else
          Chef::Log.info("device #{device_id} not ready - sleeping 10s")
          sleep 10
        end
      end
    end
  end

  # execute 'mkfs' do
  #   command "mkfs -t xfs #{device_id}"
  #   not_if "parted -l | grep -qs '#{device_id}'"
  # end

  mount mount_point do
    device device_id
    fstype 'xfs'
    action [:enable, :mount]
  end

end
