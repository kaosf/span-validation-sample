FactoryGirl.define do
  factory :schedule do
    title 'Title'
    start_at  Time.new(2014, 10, 15, 0, 0, 0, +9 * 60 * 60)
    finish_at Time.new(2014, 10, 15, 0, 0, 3, +9 * 60 * 60)
  end
end
