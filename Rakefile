require 'foodcritic'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'

CLEAN.include %w(.kitchen/ coverage/)
CLOBBER.include %w(Berksfile.lock Gemfile.lock)

namespace :style do
  RuboCop::RakeTask.new(:ruby)

  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      cookbook_paths: '.',
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']
