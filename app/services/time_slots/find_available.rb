# frozen_string_literal: true

module TimeSlots
  class FindAvailable

    def initialize(duration: 15.minutes.in_days, requested_date: Date.current)
      @requested_date = requested_date
      @duration = duration
    end

    def call
      find_available_time_slots
      available_timeslots
    end

    private

    attr_reader :requested_date, :duration

    delegate :first_possible_start, :last_possible_start, :minimum_booking_duration, to: :booking_date

    def find_available_time_slots
      first_possible_start.step(last_possible_start, minimum_booking_duration) do |proposed_time_start|
        proposed_time_end = proposed_time_start + duration
        proposed_time_slot = TimeSlot.new(start: proposed_time_start, end: proposed_time_end)

        covers_existing_time_slot = booked_time_slots.any? do |booked_timeslot|
          proposed_time_slot.covers_booked_time_slot?(booked_timeslot)
        end

        available_timeslots << proposed_time_slot unless covers_existing_time_slot
      end
    end

    def booked_time_slots
      @booked_time_slots ||= BookedTimeSlot.by_date(requested_date)
    end

    def available_timeslots
      @available_timeslots ||= []
    end

    def booking_date
      @booking_date ||= BookingDate.new(date: requested_date, booking_duration: duration)
    end

  end
end
