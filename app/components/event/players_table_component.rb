# frozen_string_literal: true

class Event
  class PlayersTableComponent < ApplicationComponent
    def initialize(event:)
      super()

      @event         = event
      @registrations = event.registrations.includes(:player)
    end
  end
end
