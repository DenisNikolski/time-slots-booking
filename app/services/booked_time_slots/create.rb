# frozen_string_literal: true

module BookedTimeSlots
  class Create

    prepend SimpleCommand

    def initialize(attributes, form: Form)
      @form = form.new.call(attributes)
    end

    def call
      return errors.add(:errors, form.errors.to_hash) if form.failure?
      return errors.add(:errors, booked_time_slot.errors.messages) unless booked_time_slot.save

      booked_time_slot
    end

    private

    attr_reader :form

    def booked_time_slot
      @booked_time_slot ||= BookedTimeSlot.new(form.to_h)
    end

  end
end
