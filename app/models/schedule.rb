class Schedule < ActiveRecord::Base
  validates_presence_of :title
  validate :valid_span?

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
    others.reduce(false) { |s, i| s || collide_to?(i) }
  end

  def collide_to?(other)
    start_at <= other.finish_at && other.start_at <= finish_at
  end
end
