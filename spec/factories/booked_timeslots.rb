# frozen_string_literal: true

FactoryBot.define do
  factory :booked_time_slot do |timeslot|
    timeslot.start { '2023-01-11 00:00:00.000000' }
    timeslot.end { '2023-01-11 00:45:00.000000' }
  end
end
