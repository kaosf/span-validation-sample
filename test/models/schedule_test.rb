require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  setup do
    @schedule = create :schedule
    @start_at = @schedule.start_at
    @finish_at = @schedule.finish_at
  end

  test "validation" do
    @schedule.finish_at = @start_at
    assert_not @schedule.valid?

    @schedule.finish_at = @start_at -1
    assert_not @schedule.valid?
  end

  teardown do
  end
end
