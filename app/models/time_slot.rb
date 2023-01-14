# frozen_string_literal: true

TimeSlot = Data.define(:start, :end) do
  def covers_booked_time_slot?(booked_time_slot)
    start < booked_time_slot.end && self.end > booked_time_slot.start
  end
end
