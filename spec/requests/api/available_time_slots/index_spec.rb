# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Index Available Time Slots' do
  path '/api/available_time_slots' do
    get('Available Time Slots') do
      parameter name: :requested_date, in: :query, type: :date
      parameter name: :booking_duration, in: :query, type: :integer

      tags 'Available Time Slots'
      produces 'application/json'

      let(:date) { Date.parse('2023-01-12') }
      before { travel_to(date) }

      response 200, 'when valid params' do
        let(:requested_date) { date.to_s }
        let(:booking_duration) { 45 }

        context 'when no available time slots' do
          before { create(:booked_time_slot, start: date.beginning_of_day, end: date.next.beginning_of_day) }

          run_test! do |response|
            available_time_slots = JSON.parse(response.body)
            expect(available_time_slots).to be_an_instance_of(Array)
          end
        end

        context 'when available time slots exists' do
          before { create(:booked_time_slot, start: date.beginning_of_day, end: date.beginning_of_day + 2.hours) }

          run_test! do |response|
            available_time_slots = JSON.parse(response.body)
            expect(available_time_slots).to be_an_instance_of(Array)
          end
        end
      end

      response 422, 'when invalid params' do
        let(:requested_date) { 'wrong' }
        let(:booking_duration) { 10 }

        run_test! do |response|
          available_time_slots = JSON.parse(response.body)
          expect(available_time_slots['errors']).not_to be_empty
        end
      end
    end
  end
end
