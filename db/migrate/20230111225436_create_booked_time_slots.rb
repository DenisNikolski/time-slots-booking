# frozen_string_literal: true

class CreateBookedTimeSlots < ActiveRecord::Migration[7.0]

  def change
    create_table :booked_time_slots do |t|

      t.datetime :start, null: false
      t.datetime :end, null: false

      t.timestamps
    end
  end

end
