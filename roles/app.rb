name 'app'
description 'App servers'
run_list(
  'recipe[rubygems-app]',
  'recipe[rubygems-app::unicorn]',
  'recipe[rubygems-app::nginx]'
)
