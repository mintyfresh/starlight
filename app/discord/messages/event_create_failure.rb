# frozen_string_literal: true

module Messages
  class EventCreateFailure < Base
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
      [
        'Failed to create event due to the following errors:',
        *@event.errors.full_messages.map { |message| "- #{message}" }
      ].join("\n")
    end
  end
end
