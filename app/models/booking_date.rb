# frozen_string_literal: true

class BookingDate

  def initialize(datetime:, booking_duration:)
    @first_possible_start = datetime.beginning_of_day
    @last_possible_start = datetime.next.beginning_of_day - booking_duration
  end

  def minimum_booking_duration
    @minimum_booking_duration ||= Rails.configuration.x.time_slot.minimum_duration_int.minutes.in_days
  end

  def possible_booking_starts
    first_possible_start.step(last_possible_start, minimum_booking_duration).to_a
  end

  attr_reader :first_possible_start, :last_possible_start

end
