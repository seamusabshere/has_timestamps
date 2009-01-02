Gem::Specification.new do |s|
  s.name     = "has_timestamps"
  s.version  = "1.2"
  s.date     = "2009-01-02"
  s.summary  = "Rails plugin to add named timestamps to ActiveRecord models."
  s.email    = "seamus@abshere.net"
  s.homepage = "http://github.com/seamusabshere/has_timestamps"
  s.description = "has_timestamps is a Rails plugin that allows you to add named timestamps to ActiveRecord models without adding database columns."
  s.has_rdoc = false
  s.authors  = "Seamus Abshere"
  s.files    = [
    "has_timestamps.gemspec",
    "lib/has_timestamps.rb",
    "lib/timestamp.rb",
    "MIT-LICENSE",
    "Rakefile",
    "README",
    "tasks/has_timestamps_tasks.rake",
    "init.rb",
    "rails/init.rb"
    ]
  s.test_files = [  
    "test/has_timestamps_test.rb",
    "test/test_helper.rb"
    ]
end
