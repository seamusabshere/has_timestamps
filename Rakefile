require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the has_timestamps plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the has_timestamps plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HasTimestamps'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name        = "has_timestamps"
    s.summary     = "Rails plugin to add named timestamps to ActiveRecord models."
    s.email       = "seamus@abshere.net"
    s.homepage    = "http://github.com/seamusabshere/has_timestamps"
    s.description = "has_timestamps is a Rails plugin that allows you to add named timestamps to ActiveRecord models without adding database columns."
    s.authors     = "Seamus Abshere"
    s.files       = FileList["[A-Z]*.*", "{bin,generators,lib,test,spec}/**/*", "init.rb", "rails/**/*"] # first two are jeweler defaults
    s.test_files = [ "test/has_timestamps_test.rb" ]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
