require 'rubocop/rake_task'
require 'foodcritic'
# require 'rspec/core/rake_task'
require 'English'

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.files = [File.join(Dir.pwd, 'cookbooks')]
  t.options = {
    fail_tags: ['any'],
    chef_version: '12.5.1',
    progress: true,
    tags: [
      '~FC003',
      '~FC011',
      '~FC015',
      '~FC017',
      '~FC023'
    ]
  }
end
