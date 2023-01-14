# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Create Book Time Slot' do
  path '/api/booked_time_slots' do
    let(:date) { Time.utc(2023, 1, 12) }
    before { travel_to(date) }

    post('Create Book Time Slot') do
      parameter name: :request_body, in: :body, required: true, schema: {
        type: :object,
        properties: {
          start: { type: :string, format: 'date-time' },
          end: { type: :string, format: 'date-time' }
        }
      }

      tags 'Booked Time Slots'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'ok - When valid params') do
        let(:request_body) do
          {
            start: (date.beginning_of_day + 1.hour).as_json,
            end: (date.beginning_of_day + 2.hours).as_json
          }
        end

        run_test! do |response|
          response_body = JSON.parse(response.body).with_indifferent_access
          expect(response_body).to match(hash_including(
                                           id: kind_of(Integer),
                                           start: request_body[:start],
                                           end: request_body[:end]
                                         ))
        end
      end

      response(422, 'Unprocessable Entity - When invalid params') do
        let(:request_body) do
          {
            start: 'wrong value',
            end: date - 2.days
          }
        end

        run_test! do |response|
          response_body = JSON.parse(response.body)
          expect(response_body['errors'])
            .to eq({
                     'start' => ['must be a date time'],
                     'end' => ['must be greater than or equal to 2023-01-12T00:00:00+00:00']
                   })
        end

        context 'when time interval overlaps with the existing' do
          let(:request_body) do
            {
              start: date.beginning_of_day + 30.minutes,
              end: date.beginning_of_day + 2.hours
            }
          end

          before do
            create(:booked_time_slot,
                   start: date.beginning_of_day + 15.minutes,
                   end: date.beginning_of_day + 2.hours)
          end

          run_test! do |response|
            response_body = JSON.parse(response.body)
            expect(response_body['errors'])
              .to eq({ 'start' => ['selected time interval overlaps with the existing'] })
          end
        end
      end
    end
  end
end
