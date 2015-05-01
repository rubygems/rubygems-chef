name 'log'
description 'Logging server'
run_list(
  'recipe[rubygems]',
  'recipe[rubygems-logging::server]'
)
