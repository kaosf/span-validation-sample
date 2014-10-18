class Schedule < ActiveRecord::Base
  validates_presence_of :title
  validate :valid_span?
  validate :span_not_collide_to_others?

  # Check `start_at` and `finish_at` are valid.
  # @return [Boolean] Whether this is valid.
  def valid_span?
    if finish_at <= start_at
      errors.add(:start_at, 'Span is invalid.')
      errors.add(:finish_at, 'Span is invalid.')
    end
  end

  def span_not_collide_to_others?
    if new_record?
      others = Schedule.all
    else
      others = Schedule.where('id != ?', id)
    end
    others.each do |i|
      if collide_to?(i)
        errors.add(:start_at, 'Span collides to another.')
        errors.add(:finish_at, 'Span collides to another.')
        break
      end
    end
  end

  # Check whether this collides to another.
  # @param [Schedule] another Another schedule record
  # @return [Boolean] Whether this collides to another schedule.
  def collide_to?(another)
    start_at <= another.finish_at && another.start_at <= finish_at
  end
end
