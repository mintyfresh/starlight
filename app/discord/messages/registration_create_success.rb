# frozen_string_literal: true

module Messages
  class RegistrationCreateSuccess < Base
    # @param registration [Registration]
    def initialize(registration)
      super()

      @registration = registration
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
        You've been registered for #{@registration.event.name}.
        You can view your registration and additional event details by clicking the button below.
        If you need to drop from the event, you can also do so from the event page.
      CONTENT
    end

    # @return [Discord::Components::ActionRow]
    def action_row
      Discord::Components::ActionRow.new(components: [view_online_button])
    end

    # @return [Discord::Components::Button]
    def view_online_button
      Components::Event::ViewOnlineButton.render(@registration.event)
    end
  end
end
