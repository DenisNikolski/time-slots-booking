# frozen_string_literal: true

class BookingDate

  MINIMUM_BOOKING_DURATION = 15.minutes.in_days
  private_constant :MINIMUM_BOOKING_DURATION

  def initialize(date:, booking_duration:)
    @first_possible_start = date.beginning_of_day
    @last_possible_start = date.next.beginning_of_day - booking_duration
  end

  def minimum_booking_duration
    MINIMUM_BOOKING_DURATION
  end

  attr_reader :first_possible_start, :last_possible_start

end
