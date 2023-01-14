# frozen_string_literal: true

module Api
  class AvailableTimeSlotsController < ApplicationController

    def index
      service = TimeSlots::FindAvailable.new(requested_date: params[:requested_date],
                                             booking_duration: params[:booking_duration]).call
      return render json: service.errors, status: :unprocessable_entity if service.failure?

      render json: TimeSlotSerializer.render(service.result)
    end

  end
end
