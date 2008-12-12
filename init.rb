require 'has_timestamps'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::HasTimestamps)

require File.dirname(__FILE__) + '/lib/timestamp'
