require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  setup do
    @schedule = create :schedule
  end

  test 'title is present' do
    assert_not_nil @schedule.title
    assert_equal 'Title', @schedule.title
  end

  teardown do
  end
end
