# frozen_string_literal: true

module TimeSlots
  class FindAvailable

    def initialize(booking_duration: 15.minutes.in_days, requested_date: Date.current)
      # TODO: add validation form
      @requested_date = requested_date
      @booking_duration = booking_duration
    end

    def call
      find_available_time_slots
      available_timeslots
    end

    private

    attr_reader :requested_date, :booking_duration

    delegate :first_possible_start, :last_possible_start, :minimum_booking_duration, to: :booking_date

    def find_available_time_slots
      first_possible_start.step(last_possible_start, minimum_booking_duration) do |proposed_time_start|
        proposed_time_slot = TimeSlot.new(start: proposed_time_start, duration: booking_duration)
        next if booked_time_slots.any? { proposed_time_slot.overlaps_with?(_1) }

        available_timeslots << proposed_time_slot
      end
    end

    def booked_time_slots
      @booked_time_slots ||= BookedTimeSlot.by_date(requested_date)
    end

    def available_timeslots
      @available_timeslots ||= []
    end

    def booking_date
      @booking_date ||= BookingDate.new(date: requested_date, booking_duration: booking_duration)
    end

  end
end
