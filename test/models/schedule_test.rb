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

  class SpanCollisionTest < self
    class CollideTest < self
      test "same" do
        schedule = create :schedule
        assert schedule.collide_to?(@schedule)
      end

      test "start < other.start" do
        schedule = create :schedule, start_at: @start_at - 1
        assert schedule.collide_to?(@schedule)
      end

      test "other.finish < finish" do
        schedule = create :schedule, finish_at: @finish_at + 1
        assert schedule.collide_to?(@schedule)
      end

      test "start < other.start and other.finish < finish" do
        schedule = create(
          :schedule,
          start_at: @start_at - 1,
          finish_at: @finish_at + 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "other.start < start and other.finish = finish" do
        schedule = create(
          :schedule,
          start_at: @start_at + 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "other.start = start and finish < other.finish" do
        schedule = create(
          :schedule,
          finish_at: @finish_at - 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "other.start < start and finish < other.finish" do
        schedule = create(
          :schedule,
          start_at: @start_at + 1,
          finish_at: @finish_at - 1
        )
        assert schedule.collide_to?(@schedule)
      end
    end

    class NotCollideTest < self
      test "other.finish < start" do
        schedule = create(
          :schedule,
          start_at: @finish_at + 1,
          finish_at: @finish_at + 2
        )
        assert_not schedule.collide_to?(@schedule)
      end
    end
  end

  teardown do
  end
end
