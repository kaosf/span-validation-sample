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
        schedule = build :schedule
        assert schedule.collide_to?(@schedule)
      end

      test "start < other.start" do
        schedule = build :schedule, start_at: @start_at - 1
        assert schedule.collide_to?(@schedule)
      end

      test "other.finish < finish" do
        schedule = build :schedule, finish_at: @finish_at + 1
        assert schedule.collide_to?(@schedule)
      end

      test "start < other.start and other.finish < finish" do
        schedule = build(
          :schedule,
          start_at: @start_at - 1,
          finish_at: @finish_at + 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "other.start < start and other.finish = finish" do
        schedule = build(
          :schedule,
          start_at: @start_at + 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "other.start = start and finish < other.finish" do
        schedule = build(
          :schedule,
          finish_at: @finish_at - 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "other.start < start and finish < other.finish" do
        schedule = build(
          :schedule,
          start_at: @start_at + 1,
          finish_at: @finish_at - 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "start < other.start < finish < other.finish" do
        schedule = build(
          :schedule,
          start_at: @start_at - 1,
          finish_at: @finish_at - 1
        )
        assert schedule.collide_to?(@schedule)
      end

      test "other.start < start < other.finish < finish" do
        schedule = build(
          :schedule,
          start_at: @start_at + 1,
          finish_at: @finish_at + 1
        )
        assert schedule.collide_to?(@schedule)
      end
    end

    class NotCollideTest < self
      test "other.finish < start" do
        schedule = build(
          :schedule,
          start_at: @finish_at + 1,
          finish_at: @finish_at + 2
        )
        assert_not schedule.collide_to?(@schedule)
      end

      test "finish < other.start" do
        schedule = build(
          :schedule,
          start_at: @start_at - 2,
          finish_at: @start_at - 1
        )
        assert_not schedule.collide_to?(@schedule)
      end
    end

    class CollisionValidation < self
      test "not collide to any other" do
        schedule = build(
          :schedule,
          start_at: @finish_at + 1,
          finish_at: @finish_at + 2
        )
        assert schedule.valid?
      end

      test "collide to another" do
        schedule = build(
          :schedule,
          start_at: @finish_at - 1,
          finish_at: @finish_at + 1
        )
        assert_not schedule.valid?
        assert schedule.errors.include?(:start_at)
      end
    end
  end

  teardown do
  end
end
