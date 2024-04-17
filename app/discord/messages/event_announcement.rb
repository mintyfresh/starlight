# frozen_string_literal: true

module Messages
  class EventAnnouncement < Base
    # @param event [Event]
    def initialize(event)
      super()

      @event = event
    end

    # @return [Discord::Message]
    def render
      Discord::Message.new(
        embeds:     [embed],
        components: [action_row]
      )
    end

  private

    # @return [Discord::Embed]
    def embed
      Components::Event::DetailsEmbed.render(@event)
    end

    # @return [Discord::Components::ActionRow]
    def action_row
      Discord::Components::ActionRow.new(
        components: [register_button, view_event_button]
      )
    end

    # @return [Discord::Components::Button]
    def register_button
      Components::Event::RegisterButton.render(@event)
    end

    # @return [Discord::Components::Button]
    def view_event_button
      Discord::Components::Button.link('View Online', event_url(@event))
    end
  end
end
