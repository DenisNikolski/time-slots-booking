# frozen_string_literal: true

module Api
  class AvailableTimeSlotsController < ApplicationController

    def index
      service = TimeSlots::FindAvailable.new(find_time_slots_params).call
      return render json: service.errors, status: :unprocessable_entity if service.failure?

      render json: TimeSlotSerializer.render_as_json(service.result)
    end

    private

    def find_time_slots_params
      params.permit(:date, :booking_duration).to_h
    end

  end
end
