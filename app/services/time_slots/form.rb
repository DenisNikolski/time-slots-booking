# frozen_string_literal: true

module TimeSlots
  class Form < Dry::Validation::Contract

    params do
      required(:date).filled(:date)
      required(:booking_duration).filled(:integer, gteq?: Rails.configuration.x.time_slot.minimum_duration_int)
    end

    rule(:date) do
      key.failure('cannot be earlier than the current date in utc') if value < Date.current
    end

    rule(:booking_duration) do
      minimum_duration = Rails.configuration.x.time_slot.minimum_duration_int
      key.failure("must be a multiple of #{minimum_duration}") unless (value % minimum_duration).zero?
    end

  end
end
