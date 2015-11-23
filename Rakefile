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
      '~FC017'
    ]
  }
end

desc 'Refresh all chef vaults'
task :refresh_vaults do
  [
    'apps/kibana',
    'apps/shipit',
    'aws/credentials',
    'certs/production',
    'certs/staging',
    'certs/logstash',
    'datadog/credentials',
    'dnsimple/credentials',
    'duo/credentials',
    'hubot/credentials',
    'papertrail/credentials',
    'postgresql/datadog',
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
