name 'monitoring'
description 'Monitoring servers'
run_list(
  'recipe[rubygems-base::default]',
  'recipe[rubygems-sensu::server]'
)
