# frozen_string_literal: true

module BookedTimeSlots
  class Form < Dry::Validation::Contract

    json do
      required(:start).filled(:date_time, gteq?: DateTime.current.beginning_of_day)
      required(:end).filled(:date_time, gteq?: DateTime.current.beginning_of_day)
    end

    rule(:end, :start) do
      key.failure('must be after start date') if values[:end] <= values[:start]
    end

    rule(:start, :end) do
      duration = TimeSlot.new(start: values[:start], end_: values[:end]).duration
      minimum_duration = Rails.configuration.x.time_slot.minimum_duration_int

      if duration.zero? || (duration % minimum_duration) != 0
        key.failure("booking duration must be a multiple of #{minimum_duration}")
      end
    end

    rule(:start, :end) do
      booked_time_slots = BookedTimeSlot.arel_table
      overlaps_with_any = BookedTimeSlot.where(
        booked_time_slots[:end].gt(values[:start])
                               .and(booked_time_slots[:start].lt(values[:end]))
      ).any?

      key.failure('selected time interval overlaps with the existing') if overlaps_with_any
    end

    rule(:start, :end) do
      duration = TimeSlot.new(start: values[:start], end_: values[:end]).duration
      booking_date = BookingDate.new(datetime: values[:start], booking_duration: duration.minutes)
      valid_start = values[:start].in?(booking_date.possible_booking_starts)

      key.failure('is invalid') unless valid_start
    end

  end
end
