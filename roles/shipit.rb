name 'shipit'
description 'Service to manage deploys'
run_list(
  'recipe[rubygems]',
  'recipe[rubygems-shipit]'
)
