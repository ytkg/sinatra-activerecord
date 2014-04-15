require 'bundler'
Bundler.setup
require 'appraisal'

Bundler::GemHelper.install_tasks

task :default => :spec

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = true
end
