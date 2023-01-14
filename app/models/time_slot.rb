# frozen_string_literal: true

class TimeSlot

  attr_reader :start, :end

  def initialize(start:, end_: nil, duration: nil)
    @start = start.to_time.utc
    @end = end_&.to_time&.utc || (@start + duration)
    @duration = duration
  end

  def duration
    @duration ||= calculate_duration
  end

  def overlaps_with?(time_slot)
    start < time_slot.end && self.end > time_slot.start
  end

  private

  def calculate_duration
    ((self.end - start) / 60).to_i
  end

end
