# frozen_string_literal: true

class BookedTimeSlotSerializer < Blueprinter::Base

  identifier :id

  fields :start, :end

end
