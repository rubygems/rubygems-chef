name 'ci'
description 'CI server(s) powered by Jenkins'
run_list(
  'recipe[rubygems-ci]'
)
