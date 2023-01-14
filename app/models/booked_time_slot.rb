# frozen_string_literal: true

class BookedTimeSlot < ApplicationRecord

  scope :by_date, lambda { |date|
    where(start: date.beginning_of_day...date.next.beginning_of_day).order(:start)
  }

end
