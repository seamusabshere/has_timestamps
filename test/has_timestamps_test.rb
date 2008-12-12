require File.dirname(__FILE__) + '/test_helper'

class Person < ActiveRecord::Base
  has_timestamps
end

class HasTimestampsTest < Test::Unit::TestCase
  fixtures :people, :timestamps

  def setup
    @person = people(:seamus)
    @timestamp = timestamps(:saluted)
    @now = freeze_time
    @another_time = DateTime.parse('1982-01-01T00:00:00+00:00')
  end
  
  def test_should_get_timestamp_with_brackets
    assert_equal @timestamp.stamped_at, @person.timestamps[@timestamp.key.to_sym]
  end
  
  def test_should_get_nil_timestamp_with_brackets
    assert_nil @person.timestamps[:gibberish]
  end
  
  def test_should_get_timestamp_as_datetime
    assert_equal @person.timestamps[@timestamp.key.to_sym].class, ActiveSupport::TimeWithZone
  end

  def test_should_query_timestamp_with_brackets
    assert_equal @person.timestamped?(@timestamp.key.to_sym), true
    assert_equal @person.timestamped?(:gibberish), false
  end
    
  def test_should_set_timestamp
    @person.timestamp!(:hailed)
    @person.save
    @person.reload
    assert_equal @now, @person.timestamps[:hailed]
  end
  
  def test_should_set_timestamp_manually
    @person.timestamps[:hailed] = @another_time
    @person.save
    @person.reload
    assert_equal @another_time, @person.timestamps[:hailed]
  end
  
  def test_should_set_timestamp_to_nil
    @person.timestamps[:hailed] = nil
    @person.save
    @person.reload
    assert_nil @person.timestamps[:hailed]
  end
  
  def test_should_reset_timestamp
    assert_not_equal @now, @person.timestamps[:saluted]
    @person.timestamp!(:saluted)
    @person.save
    @person.reload
    assert_equal @now, @person.timestamps[:saluted]
  end
  
  def test_should_reset_timestamp_manually
    old_time = @person.timestamps[:saluted]
    @person.timestamps[:saluted] = @another_time
    @person.save
    @person.reload
    assert_equal @another_time, @person.timestamps[:saluted]
  end
  
  def test_should_reset_timestamp_to_nil
    @person.timestamps[:saluted] = nil
    @person.save
    @person.reload
    assert_nil @person.timestamps[:saluted]
  end
  
  def test_should_save_timestamps
    assert_difference('Timestamp.count', 1) do
      @person.timestamp!(:hailed)
      @person.save
    end
  end
  
  def test_should_destroy_nil_timestamps
    assert_difference('Timestamp.count', -1) do
      @person.timestamps[:saluted] = nil
      @person.save
    end
  end
  
  def test_should_not_save_nil_timestamps
    assert_no_difference('Timestamp.count') do
      @person.timestamps[:hailed] = nil
      @person.save
    end
  end
  
  private
  
  def freeze_time
    now = Time.now.at_beginning_of_day
    Time.stubs(:now).returns(now)
    now
  end
end
