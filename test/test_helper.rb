module HasTimestampsTest
  module Initializer
    VENDOR_RAILS = File.expand_path('../../../../rails', __FILE__)
    OTHER_RAILS = File.expand_path('../../../rails', __FILE__)
    PLUGIN_ROOT = File.expand_path('../../', __FILE__)
    
    def self.rails_directory
      if File.exist?(VENDOR_RAILS)
        VENDOR_RAILS
      elsif File.exist?(OTHER_RAILS)
        OTHER_RAILS
      end
    end
    
    def self.load_dependencies
      if rails_directory
        $:.unshift(File.join(rails_directory, 'activesupport', 'lib'))
        $:.unshift(File.join(rails_directory, 'activerecord', 'lib'))
      else
        require 'rubygems' rescue LoadError
      end
      
      require 'activesupport'
      require 'activerecord'
      
      require 'rubygems' rescue LoadError
      
      require 'test/spec'
      require File.join(PLUGIN_ROOT, 'init')
    end
    
    def self.configure_database
      ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
      ActiveRecord::Migration.verbose = false
    end
    
    def self.setup_database
      ActiveRecord::Schema.define do
        create_table :people do |t|
          t.string :name
        end
        create_table :timestamps do |t|
          t.integer :timestampable_id
          t.string :timestampable_type
          t.string :key
          t.datetime :stamped_at
          t.timestamps
        end
      end
    end
    
    def self.teardown_database
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.drop_table(table)
      end
    end
    
    def self.start
      load_dependencies
      configure_database
    end
  end
end
 
HasTimestampsTest::Initializer.start
 
class Person < ActiveRecord::Base
  has_timestamps
end
