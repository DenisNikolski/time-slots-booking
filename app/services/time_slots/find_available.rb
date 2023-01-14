# frozen_string_literal: true

module TimeSlots
  class FindAvailable

    prepend SimpleCommand

    def initialize(requested_date: DateTime.current, booking_duration: 15, form: Form)
      @form = form.new.call(requested_date: requested_date, booking_duration: booking_duration)
    end

    def call
      return errors.add(:errors, form.errors.to_hash) if form.failure?

      find_available_time_slots
      available_timeslots
    end

    private

    attr_reader :form

    delegate :first_possible_start, :last_possible_start, :minimum_booking_duration, to: :booking_date

    def find_available_time_slots
      first_possible_start.step(last_possible_start, minimum_booking_duration) do |proposed_time_start|
        proposed_time_slot = TimeSlot.new(start: proposed_time_start, duration: booking_duration_in_days)
        next if booked_time_slots.any? { proposed_time_slot.overlaps_with?(_1) }

        available_timeslots << proposed_time_slot
      end
    end

    def booked_time_slots
      @booked_time_slots ||= BookedTimeSlot.by_datetime(booking_datetime)
    end

    def available_timeslots
      @available_timeslots ||= []
    end

    def booking_date
      @booking_date ||= BookingDate.new(datetime: booking_datetime, booking_duration: booking_duration_in_days)
    end

    def booking_datetime
      @booking_datetime ||= form[:requested_date].to_datetime
    end

    def booking_duration_in_days
      @booking_duration_in_days ||= form[:booking_duration].minutes.in_days
    end

  end
end
