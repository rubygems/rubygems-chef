source 'https://rubygems.org'

gem 'berkshelf',    '~> 5.0'
gem 'chef',         '~> 12.17.44'
gem 'chef-vault',   '~> 2.6.0'
gem 'knife-backup'
gem 'knife-cookbook-cleanup'

group :lint do
  gem 'foodcritic', '~> 6.0'
  gem 'rubocop', '0.45.0'
end

group :unit do
  gem 'chefspec', '~> 5.0'
end

group :kitchen do
  gem 'test-kitchen', '~> 1.6'
  gem 'kitchen-docker'
end
