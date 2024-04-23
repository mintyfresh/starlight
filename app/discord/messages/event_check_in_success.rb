# frozen_string_literal: true

module Messages
  class EventCheckInSuccess < Base
    # @param event [Event]
    def initialize(event)
      super()

      @event = event
    end

    # @return [Discord::Interaction::Response::MessageResponseData]
    def render
      Discord::Interaction::Response::MessageResponseData.new(
        content:, flags: Discord::MessageFlags::EPHEMERAL
      )
    end

  private

    # @return [String]
    def content
      <<~CONTENT.strip
        You're now checked-in for #{@event.name}.
      CONTENT
    end
  end
end
