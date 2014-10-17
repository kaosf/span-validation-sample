class Schedule < ActiveRecord::Base
  validates_presence_of :title
  validate :valid_span?

  def valid_span?
    if finish_at <= start_at
      errors.add(:start_at, 'Span is invalid.')
      errors.add(:finish_at, 'Span is invalid.')
    end
  end
end
