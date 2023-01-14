# frozen_string_literal: true

class TimeSlot

  attr_reader :start, :end

  def initialize(start:, duration:)
    @start = start
    @end = start + duration
  end

  def overlaps_with?(time_slot)
    start < time_slot.end && self.end > time_slot.start
  end

end
