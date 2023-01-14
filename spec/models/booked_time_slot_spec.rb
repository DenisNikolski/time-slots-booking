# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookedTimeSlot do
  describe '#by_date' do
    subject(:model) { described_class.by_datetime(date) }

    let(:date) { Date.new(2023, 1, 12) }
    let(:time_slot_day_before1) do
      create(:booked_time_slot, start: '2023-01-11 12:30:00.000000', end: '2023-01-11 14:00:00.000000')
    end
    let(:time_slot_day_before2) do
      create(:booked_time_slot, start: '2023-01-11 23:45:00.000000', end: '2023-01-12 00:00:00.000000')
    end
    let(:time_slot_day_after1) do
      create(:booked_time_slot, start: '2023-01-13 00:00:00.000000', end: '2023-01-13 14:00:00.000000')
    end
    let(:time_slot_day_after2) do
      create(:booked_time_slot, start: '2023-01-13 18:00:00.000000', end: '2023-01-13 19:00:00.000000')
    end

    before do
      time_slot_day_before1
      time_slot_day_before2
      time_slot_day_after1
      time_slot_day_after2
    end

    context 'when no booked time slots for given date' do
      it { is_expected.to be_empty }
    end

    context 'when booked time slots for given date exists' do
      let(:time_slot1) do
        create(:booked_time_slot, start: '2023-01-12 00:00:00.000000', end: '2023-01-12 14:00:00.000000')
      end
      let(:time_slot2) do
        create(:booked_time_slot, start: '2023-01-12 18:00:00.000000', end: '2023-01-12 19:00:00.000000')
      end
      let(:time_slot3) do
        create(:booked_time_slot, start: '2023-01-12 23:00:00.000000', end: '2023-01-13 00:00:00.000000')
      end

      before do
        time_slot1
        time_slot2
        time_slot3
      end

      it 'returns time slots for given date' do
        expect(model).to match_array([time_slot1, time_slot2, time_slot3])
      end
    end
  end
end
