# frozen_string_literal: true

module TimeSlots
  class FindAvailable

    def initialize(duration: 15.minutes.in_days, date: Date.current)
      @date = date
      @duration = duration
      @available_timeslots = []
    end

    def call
      beginning_of_the_day = date.beginning_of_day
      last_possible_start = date.next.beginning_of_day - duration
      find_available_timeslots(beginning_of_the_day, last_possible_start)

      available_timeslots
    end

    private

    attr_accessor :available_timeslots
    attr_reader :date, :duration

    def find_available_timeslots(beginning_of_the_day, last_possible_start)
      beginning_of_the_day.step(last_possible_start, 15.minutes.in_days) do |proposed_time_start|
        proposed_time_end = proposed_time_start + duration
        proposed_time_slot = TimeSlot.new(start: proposed_time_start, end: proposed_time_end)

        covers_existing_time_slot = booked_time_slots.any? do |booked_timeslot|
          proposed_time_slot.covers_booked_time_slot?(booked_timeslot)
        end

        available_timeslots << proposed_time_slot unless covers_existing_time_slot
      end
    end

    def booked_time_slots
      @booked_time_slots ||= BookedTimeSlot.by_date(date)
    end

  end
end
