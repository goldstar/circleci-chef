require 'foodcritic'

task :default => [:foodcritic]

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    :cookbook_paths => '.'
  }
end
