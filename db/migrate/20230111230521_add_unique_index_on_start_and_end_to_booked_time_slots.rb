# frozen_string_literal: true

class AddUniqueIndexOnStartAndEndToBookedTimeSlots < ActiveRecord::Migration[7.0]

  def change
    add_index :booked_time_slots, %i[start end], unique: true
  end

end
