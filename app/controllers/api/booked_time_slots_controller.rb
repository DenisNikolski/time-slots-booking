# frozen_string_literal: true

module Api
  class BookedTimeSlotsController < ApplicationController

    def create
      service = BookedTimeSlots::Create.new(booked_time_slots_params).call
      return render json: service.errors, status: :unprocessable_entity if service.failure?

      render json: BookedTimeSlotSerializer.render_as_json(service.result)
    end

    private

    def booked_time_slots_params
      params.permit(:start, :end).to_h
    end

  end
end
