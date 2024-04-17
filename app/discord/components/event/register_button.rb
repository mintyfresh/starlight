# frozen_string_literal: true

module Components
  module Event
    class RegisterButton < Button
      # @param request [Discord::Interaction::Request]
      # @param event [Event]
      on_click do |request, event|
        user = request.member.user || request.user
        user = User.upsert_from_discord!(user)

        if event.register(user)
          content = 'You have successfully registered for the event!'
        else
          content  = "Failed to register due to the following errors:\n"
          content += event.errors.full_messages.join("\n")
        end

        Discord::Interaction::Response.channel_message(
          content:, flags: Discord::MessageFlags::EPHEMERAL
        )
      end

      label 'Register'

      # @param event [Event]
      def initialize(event)
        super()

        @event = event
      end

      # @return [String]
      def custom_id
        Components.encode_custom_id(self, @event)
      end
    end
  end
end
