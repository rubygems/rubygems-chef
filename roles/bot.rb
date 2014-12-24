name 'bot'
description 'Hubot'
run_list(
  'recipe[rubygems]',
  'recipe[rubygems-hubot]'
)
