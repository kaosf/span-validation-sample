class Schedule < ActiveRecord::Base
  validates_presence_of :title
  validate :valid_span?

  def valid_span?
    if finish_at <= start_at
      errors.add(:start_at, 'Span is invalid.')
      errors.add(:finish_at, 'Span is invalid.')
    end
  end

  def collide_to?(other)
    start_at <= other.finish_at && other.start_at <= finish_at
  end
end
