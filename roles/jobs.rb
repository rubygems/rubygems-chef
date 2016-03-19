name 'jobs'
description 'Job servers'
run_list(
  'recipe[rubygems-app]',
  'recipe[rubygems-app::delayed_job]',
  'recipe[rubygems-app::shoryuken]'
)
