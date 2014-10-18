class Schedule < ActiveRecord::Base
  validates_presence_of :title
  validate :valid_span?
  validate :span_not_collide_to_others?

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

  # Check whether this collides to another
  # @param [Schedule] other Another schedule record
  # @return [true] Collide to another schedule
  # @return [false] NOT collide to another schedule
  def collide_to?(other)
    start_at <= other.finish_at && other.start_at <= finish_at
  end
end
