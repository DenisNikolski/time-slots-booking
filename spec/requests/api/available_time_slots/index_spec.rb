# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Index Available Time Slots' do
  path '/api/available_time_slots' do
    get('Available Time Slots') do
      parameter name: :date, in: :query, type: :date
      parameter name: :booking_duration, in: :query, type: :integer

      tags 'Available Time Slots'
      produces 'application/json'

      let(:server_date) { Date.parse('2023-01-12') }
      before { travel_to(server_date) }

      response 200, 'ok - when valid params' do
        let(:date) { server_date.to_s }
        let(:booking_duration) { 45 }

        context 'when no available time slots' do
          before do
            create(:booked_time_slot,
                   start: server_date.beginning_of_day,
                   end: server_date.next.beginning_of_day)
          end

          run_test! do |response|
            available_time_slots = JSON.parse(response.body)
            expect(available_time_slots).to be_an_instance_of(Array)
          end
        end

        context 'when available time slots exists' do
          before do
            create(:booked_time_slot,
                   start: server_date.beginning_of_day,
                   end: server_date.beginning_of_day + 2.hours)
          end

          run_test! do |response|
            available_time_slots = JSON.parse(response.body)
            expect(available_time_slots).to be_an_instance_of(Array)
          end
        end
      end

      response 422, 'Unprocessable Entity - when invalid params' do
        let(:date) { 'wrong' }
        let(:booking_duration) { 10 }

        run_test! do |response|
          available_time_slots = JSON.parse(response.body)
          expect(available_time_slots['errors']).not_to be_empty
        end
      end
    end
  end
end
