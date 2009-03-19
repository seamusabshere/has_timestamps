# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_timestamps}
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Seamus Abshere"]
  s.date = %q{2009-03-19}
  s.description = %q{has_timestamps is a Rails plugin that allows you to add named timestamps to ActiveRecord models without adding database columns.}
  s.email = %q{seamus@abshere.net}
  s.files = ["VERSION.yml", "lib/has_timestamps.rb", "lib/timestamp.rb", "test/has_timestamps_test.rb", "test/test_helper.rb", "init.rb", "rails/init.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/seamusabshere/has_timestamps}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Rails plugin to add named timestamps to ActiveRecord models.}
  s.test_files = ["test/has_timestamps_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
