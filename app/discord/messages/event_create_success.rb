# frozen_string_literal: true

module Messages
  class EventCreateSuccess < Base
    # @param event [Event]
    def initialize(event)
      super()

      @event = event
    end

    # @return [Discord::Interaction::Response::MessageResponseData]
    def render
      Discord::Interaction::Response::MessageResponseData.new(
        content:,
        components: [action_row],
        flags:      Discord::MessageFlags::EPHEMERAL
      )
    end

  private

    # @return [String]
    def content
      <<~CONTENT.strip
        Successfully created #{@event.name} as a draft.
        Follow the link below to edit the event and fill out the rest of the details.
      CONTENT
    end

    # @return [Discord::Components::ActionRow]
    def action_row
      Discord::Components::ActionRow.new(components: [edit_event_button])
    end

    # @return [Discord::Components::Button]
    def edit_event_button
      Discord::Components::Button.link('Edit Event', edit_event_url(@event))
    end
  end
end
