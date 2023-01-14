# frozen_string_literal: true

module TimeSlots
  class Form < Dry::Validation::Contract

    params do
      required(:requested_date).filled(:date)
      required(:booking_duration).filled(:integer, gteq?: 15)
    end

    rule(:requested_date) do
      key.failure('cannot be earlier than the current date') if value < Date.current
    end

    rule(:booking_duration) do
      key.failure('must be a multiple of 15') unless (value % 15).zero?
    end

  end
end
