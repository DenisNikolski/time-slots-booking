# frozen_string_literal: true

class BookedTimeSlot < ApplicationRecord

  validates :start, uniqueness: { scope: :end }

  scope :by_datetime, lambda { |date|
    where(start: date.beginning_of_day...date.next.beginning_of_day).order(:start)
  }

end
