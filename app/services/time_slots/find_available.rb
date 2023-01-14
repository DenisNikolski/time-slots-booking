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
      beginning_of_the_next_day = date.next.beginning_of_day

      booked_time_slots = BookedTimeSlot.by_date(date)

      last_possible_start = beginning_of_the_next_day - duration
      beginning_of_the_day.step(last_possible_start, 15.minutes.in_days) do |proposed_time_start|
        proposed_time_end = proposed_time_start + duration
        covers_existing_timeslot = booked_time_slots.any? do |booked_timeslot|
          proposed_time_start < booked_timeslot.end && proposed_time_end > booked_timeslot.start
        end

        available_timeslots << [proposed_time_start, proposed_time_end] unless covers_existing_timeslot
      end

      available_timeslots
    end

    private

    attr_accessor :available_timeslots
    attr_reader :date, :duration

  end
end
