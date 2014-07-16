require 'rubocop/rake_task'
require 'foodcritic'
# require 'rspec/core/rake_task'
require 'English'

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = {
    fail_tags: ['any'],
    cookbook_paths: 'cookbooks',
    tags: [
      '~FC003',
      '~FC011'
    ]
  }
end

# desc 'Run ChefSpec examples'
# RSpec::Core::RakeTask.new(:spec)

# desc 'Run all tests'
# task test: [:rubocop, :foodcritic, :spec]
# task default: :test
# task lint: :foodcritic

# begin
#   require 'kitchen/rake_tasks'
#   Kitchen::RakeTasks.new

#   desc 'Alias for kitchen:all'
#   task integration: 'kitchen:all'
#   task test_all: [:test, :integration]
# rescue LoadError
#   puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
# end

desc 'Refresh all chef vaults'
task :refresh_vaults do
  [
    'certs/production',
    'certs/staging',
    'dnsimple/credentials',
    'duo/credentials',
    'librato/credentials',
    'papertrail/credentials',
    'rubygems/production',
    'rubygems/staging',
    'secrets/backups',
    'sensu/credentials',
    'slack/credentials'
  ].each do |item|
    pair = item.split('/')
    system "knife vault refresh #{pair[0]} #{pair[1]}"
    puts "Successfully updated the #{item} vault" if $CHILD_STATUS.exitstatus == 0
  end
end
