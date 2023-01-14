# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeSlots::Form do
  subject(:form) { described_class.new.call(params) }

  context 'when params are valid' do
    let(:params) { { date: Date.current, booking_duration: 30 } }

    it { is_expected.to be_success }
  end

  context 'when params are invalid' do
    context 'when params are missing' do
      let(:params) { {} }
      let(:expected_errors) do
        { booking_duration: ['is missing'],
          date: ['is missing'] }
      end

      it 'returns errors' do
        expect(form.errors.to_hash).to eq(expected_errors)
      end
    end

    context 'when params filled with wrong value' do
      let(:params) { { date: 'wrong_value', booking_duration: 10 } }
      let(:expected_errors) do
        { booking_duration: ['must be greater than or equal to 15'],
          date: ['must be a date'] }
      end

      it 'returns errors' do
        expect(form.errors.to_hash).to eq(expected_errors)
      end
    end

    context 'when validation rules are not satisfied' do
      let(:params) { { date: Date.current - 1.day, booking_duration: 99 } }
      let(:expected_errors) do
        { booking_duration: ['must be a multiple of 15'],
          date: ['cannot be earlier than the current date in utc'] }
      end

      it 'returns errors' do
        expect(form.errors.to_hash).to eq(expected_errors)
      end
    end
  end
end
