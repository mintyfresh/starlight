# frozen_string_literal: true

module Components
  module Event
    class RegisterButton < Button
      # @param request [Discord::Interaction::Request]
      # @param event [Event]
      on_click do |request, event|
        user = request.member.user || request.user
        user = User.upsert_from_discord!(user)

        registration = event.registrations.find_or_initialize_by(player: user)

        if event.decklist_permitted?
          return Components::Registration::RegisterModal.render(registration)
        elsif registration.save(content: :register)
          message = Messages::RegistrationCreateSuccess.render(registration)
        else
          content  = "Failed to register due to the following errors:\n"
          content += event.errors.full_messages.join("\n")
          message  = { content:, flags: Discord::MessageFlags::EPHEMERAL }
        end

        Discord::Interaction::Response.channel_message(message)
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
