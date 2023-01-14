# frozen_string_literal: true

module TimeSlots
  class FindAvailable

    prepend SimpleCommand

    def initialize(attributes, form: Form)
      @form = form.new.call(attributes)
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
        proposed_time_slot = TimeSlot.new(start: proposed_time_start, duration: booking_duration_minutes)
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
      @booking_date ||= BookingDate.new(datetime: booking_datetime,
                                        booking_duration: booking_duration_minutes.in_days)
    end

    def booking_datetime
      @booking_datetime ||= form[:date].to_datetime
    end

    def booking_duration_minutes
      @booking_duration_minutes ||= form[:booking_duration].minutes
    end

  end
end
