require File.expand_path('../test_helper', __FILE__)
require 'active_support/testing/core_ext/test/unit/assertions'
require 'mocha'

describe "HasTimestamps" do
  before do
    HasTimestampsTest::Initializer.setup_database
    create_person
    @person = Person.first
    @timestamp = Timestamp.first
    @now = freeze_time
    @another_time = Time.now.yesterday
  end
  
  after do
    HasTimestampsTest::Initializer.teardown_database
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
    assert_equal @now, @person.timestamps[:hailed]
  end
  
  it "should set timestamp manually" do
    @person.timestamps[:hailed] = @another_time
    @person.save
    @person.reload
    assert_equal @another_time, @person.timestamps[:hailed]
  end
  
  it "should set timestamp manually to Date" do
    @person.timestamps[:hailed] = @another_time.to_date
    @person.save
    @person.reload
    assert_equal @another_time, @person.timestamps[:hailed]
  end
  
  it "should set timestamp manually to DateTime" do
    @person.timestamps[:hailed] = @another_time.to_datetime
    @person.save
    @person.reload
    assert_equal @another_time, @person.timestamps[:hailed]
  end
  
  it "should set timestamp to nil" do
    @person.timestamps[:hailed] = nil
    @person.save
    @person.reload
    assert_nil @person.timestamps[:hailed]
  end
  
  it "should reset timestamp" do
    old_time = @person.timestamps[:saluted]
    @person.timestamp!(:saluted)
    @person.save
    @person.reload
    assert_not_equal old_time, @person.timestamps[:saluted]
    assert_equal @now, @person.timestamps[:saluted]
  end
  
  it "should reset timestamp manually" do
    old_time = @person.timestamps[:saluted]
    @person.timestamps[:saluted] = @another_time
    @person.save
    @person.reload
    assert_not_equal old_time, @person.timestamps[:saluted]
    assert_equal @another_time, @person.timestamps[:saluted]
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
  
  private
  
  def create_person
    person_fixture = Person.create :name => 'Seamus'
    person_fixture.timestamp!(:saluted)
    person_fixture.save
  end
  
  def freeze_time
    now = Time.now.at_beginning_of_day
    Time.stubs(:now).returns(now)
    now
  end
end
