name 'redis'
description 'Redis servers'
run_list(
  'recipe[rubygems-redis]'
)
