# frozen_string_literal: true

class Event
  class DetailsComponent < ApplicationComponent
    # @param event [Event]
    def initialize(event:)
      @event = event
    end
  end
end
