require 'rubygems'
require 'rubygems/package_task'
require 'rake'
require 'rspec/core/rake_task'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('target')

RSpec::Core::RakeTask.new(:test) do |test|
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

task :default => :test
