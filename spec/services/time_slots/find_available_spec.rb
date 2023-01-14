# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeSlots::FindAvailable do
  subject(:instance) { described_class.new(requested_date: date, booking_duration: booking_duration).call }

  let(:date) { DateTime.new(2023, 11, 1) }

  context 'when no booked time slots' do
    context 'when duration is 15 minutes' do
      let(:booking_duration) { 15.minutes.in_days }

      it 'returns all 96 possible slots' do
        expect(instance.count).to eq(96)
      end
    end

    context 'when duration is 45 minutes' do
      let(:booking_duration) { 45.minutes.in_days }

      it 'returns all 45 possible slots' do
        expect(instance.count).to eq(94)
      end
    end

    context 'when duration is 2 hours' do
      let(:booking_duration) { 2.hours.in_days }

      it 'returns all 89 possible slots' do
        expect(instance.count).to eq(89)
      end
    end
  end

  context 'when all slots are booked' do
    before { create(:booked_time_slot, start: date.beginning_of_day, end: date.next.beginning_of_day) }

    context 'when duration is 15 minutes' do
      let(:booking_duration) { 15.minutes.in_days }

      it { is_expected.to be_empty }
    end

    context 'when duration is 3h 45 minutes' do
      let(:booking_duration) { 3.hours.in_days + 45.minutes.in_days }

      it { is_expected.to be_empty }
    end
  end

  context 'when no free timeslots for given duration' do
    let(:booking_duration) { 4.hours.in_days }
    let(:first_booking) do
      create(:booked_time_slot, start: date.beginning_of_day + 15.minutes, end: date.beginning_of_day + 45.minutes)
    end

    before do
      create(:booked_time_slot, start: first_booking.end, end: date.next.beginning_of_day)
    end

    it { is_expected.to be_empty }
  end

  context 'when booked slots are all over the day' do
    before { create_booked_time_slots }

    context 'when duration is 15 minutes' do
      let(:booking_duration) { 15.minutes.in_days }
      let(:expected_start_dates) do
        ['Wed, 01 Nov 2023 00:00:00 +0000',
         'Wed, 01 Nov 2023 00:15:00 +0000',
         'Wed, 01 Nov 2023 00:30:00 +0000',
         'Wed, 01 Nov 2023 06:00:00 +0000',
         'Wed, 01 Nov 2023 07:00:00 +0000',
         'Wed, 01 Nov 2023 07:15:00 +0000',
         'Sun, 01 Nov 2023 08:00:00 +0000',
         'Sun, 01 Nov 2023 08:15:00 +0000',
         'Sun, 01 Nov 2023 08:30:00 +0000',
         'Sun, 01 Nov 2023 08:45:00 +0000',
         'Wed, 01 Nov 2023 09:00:00 +0000',
         'Wed, 01 Nov 2023 09:15:00 +0000',
         'Wed, 01 Nov 2023 09:30:00 +0000',
         'Wed, 01 Nov 2023 09:45:00 +0000',
         'Wed, 01 Nov 2023 10:00:00 +0000',
         'Wed, 01 Nov 2023 10:15:00 +0000',
         'Wed, 01 Nov 2023 11:00:00 +0000',
         'Wed, 01 Nov 2023 11:15:00 +0000',
         'Wed, 01 Nov 2023 11:30:00 +0000',
         'Wed, 01 Nov 2023 11:45:00 +0000',
         'Wed, 01 Nov 2023 23:45:00 +0000']
      end

      it 'returns correct time slots' do
        expect(instance).to match_array_having_attributes(expected_start_dates, booking_duration)
      end
    end

    context 'when duration is 30 minutes' do
      let(:booking_duration) { 30.minutes.in_days }
      let(:expected_start_dates) do
        ['Wed, 01 Nov 2023 00:00:00 +0000',
         'Wed, 01 Nov 2023 00:15:00 +0000',
         'Wed, 01 Nov 2023 07:00:00 +0000',
         'Wed, 01 Nov 2023 08:00:00 +0000',
         'Wed, 01 Nov 2023 08:15:00 +0000',
         'Wed, 01 Nov 2023 08:30:00 +0000',
         'Wed, 01 Nov 2023 08:45:00 +0000',
         'Wed, 01 Nov 2023 09:00:00 +0000',
         'Wed, 01 Nov 2023 09:15:00 +0000',
         'Wed, 01 Nov 2023 09:30:00 +0000',
         'Wed, 01 Nov 2023 09:45:00 +0000',
         'Wed, 01 Nov 2023 10:00:00 +0000',
         'Wed, 01 Nov 2023 11:00:00 +0000',
         'Wed, 01 Nov 2023 11:15:00 +0000',
         'Wed, 01 Nov 2023 11:30:00 +0000']
      end

      it 'returns correct time slots' do
        expect(instance).to match_array_having_attributes(expected_start_dates, booking_duration)
      end
    end

    context 'when duration is 4 hours' do
      let(:booking_duration) { 4.hours.in_days }

      it { is_expected.to be_empty }
    end
  end

  def create_booked_time_slots # rubocop:disable Metrics/AbcSize
    create(:booked_time_slot,
           start: date.beginning_of_day + 45.minutes,
           end: date.beginning_of_day + 1.hour)
    create(:booked_time_slot,
           start: date.beginning_of_day + 1.hour,
           end: date.beginning_of_day + 6.hours)
    create(:booked_time_slot,
           start: date.beginning_of_day + 6.hours + 15.minutes,
           end: date.beginning_of_day + 7.hours)
    create(:booked_time_slot,
           start: date.beginning_of_day + 7.hours + 30.minutes,
           end: date.beginning_of_day + 8.hours)
    create(:booked_time_slot,
           start: date.beginning_of_day + 10.hours + 30.minutes,
           end: date.beginning_of_day + 11.hours)
    create(:booked_time_slot,
           start: date.beginning_of_day + 12.hours,
           end: date.next.beginning_of_day - 15.minutes)
  end

  def match_array_having_attributes(time_slots_strings, duration)
    match_array(
      time_slots_strings.map do |start_str|
        time_slot = TimeSlot.new(start: DateTime.parse(start_str), duration: duration)
        have_attributes({ start: time_slot.start, end: time_slot.end })
      end
    )
  end
end
