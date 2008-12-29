require File.expand_path('../test_helper', __FILE__)

module SharedTests
  def self.included(klass)
    klass.class_eval do
      it "should test if two times are virtually simultaneous" do
        t1 = Time.at(946702800)
        t2 = Time.at(946702800 + DELTA_IN_SECONDS)
        t3 = Time.at(946702800 + DELTA_IN_SECONDS + 1)
        assert_simultaneous(t1, t2)
        assert_not_simultaneous(t1, t3)
      end
      
      it "should get timestamp with brackets" do
        assert_equal @timestamp.stamped_at, @person.timestamps[@timestamp.key.to_sym]
      end

      it "should get nil timestamp with brackets" do
        assert_nil @person.timestamps[:gibberish]
      end

      it "should get timestamp as a Time" do
        assert @person.timestamps[@timestamp.key.to_sym].acts_like?(:time)
      end

      it "should query timestamp with brackets" do
        assert_equal @person.timestamped?(@timestamp.key.to_sym), true
        assert_equal @person.timestamped?(:gibberish), false
      end
      
      it "should set timestamp" do
        @person.timestamp!(:hailed)
        @person.save
        @person.reload
        assert_simultaneous Time.now, @person.timestamps[:hailed]
      end

      it "should reset timestamp" do
        old_time = @person.timestamps[:saluted]
        @person.timestamp!(:saluted)
        @person.save
        @person.reload
        assert_not_simultaneous(old_time, @person.timestamps[:saluted])
        assert_simultaneous Time.now, @person.timestamps[:saluted]
      end
      
      it "should set timestamp manually" do
        @person.timestamps[:hailed] = @another_time
        @person.save
        @person.reload
        assert_simultaneous @another_time, @person.timestamps[:hailed]
      end
      
      it "should set timestamp manually to Date" do
        @person.timestamps[:hailed] = @another_time.to_date
        @person.save
        @person.reload
        assert_simultaneous @another_time, @person.timestamps[:hailed]
      end
      
      it "should set timestamp manually to DateTime" do
        @person.timestamps[:hailed] = @another_time.to_datetime
        @person.save
        @person.reload
        assert_simultaneous @another_time, @person.timestamps[:hailed]
      end
      
      it "should set timestamp to nil" do
        @person.timestamps[:hailed] = nil
        @person.save
        @person.reload
        assert_nil @person.timestamps[:hailed]
      end
      
      it "should reset timestamp manually" do
        old_time = @person.timestamps[:saluted]
        @person.timestamps[:saluted] = @another_time
        @person.save
        @person.reload
        assert_not_simultaneous old_time, @person.timestamps[:saluted]
        assert_simultaneous @another_time, @person.timestamps[:saluted]
      end
      
      it "should reset timestamp to nil" do
        @person.timestamps[:saluted] = nil
        @person.save
        @person.reload
        assert_nil @person.timestamps[:saluted]
      end
      
      it "should save timestamps" do
        assert_difference('Timestamp.count', 1) do
          @person.timestamp!(:hailed)
          @person.save
        end
      end
      
      it "should destroy nil timestamps" do
        assert_difference('Timestamp.count', -1) do
          @person.timestamps[:saluted] = nil
          @person.save
        end
      end
      
      it "should not save nil timestamps" do
        assert_no_difference('Timestamp.count') do
          @person.timestamps[:hailed] = nil
          @person.save
        end
      end
    end
  end
end

describe "HasTimestamps, when a timezone is not set" do
  before do
    HasTimestampsTest::Initializer.setup_database
    @person = Person.first
    @timestamp = Timestamp.first
    @another_time = 3.days.ago.at_beginning_of_day
  end
  after do
    HasTimestampsTest::Initializer.teardown_database
  end
  
  it "should not have a timezone" do
    assert_nil Time.zone
  end
  
  include SharedTests
end

describe "HasTimestamps, when a timezone is set" do
  before do
    HasTimestampsTest::Initializer.setup_database
    Time.zone = 'Pacific Time (US & Canada)'
    @person = Person.first
    @timestamp = Timestamp.first
    @another_time = 3.days.ago.at_beginning_of_day
  end
  after do
    HasTimestampsTest::Initializer.teardown_database
  end
  
  it "should have a timezone" do
    assert_equal Time.zone.name, 'Pacific Time (US & Canada)'
  end
  
  include SharedTests
end
