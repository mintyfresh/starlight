# frozen_string_literal: true

module Components
  module Event
    class RegisterButton < Button
      # @param request [Discord::Interaction::Request]
      # @param event [Event]
      on_click do |request, event|
        user = request.member.user || request.user
        user = User.upsert_from_discord!(user)

        if event.decklist_permitted?
          registration = event.registrations.find_or_initialize_by(player: user)
          return Modals::RegistrationModal.render(registration)
        end

        registration = event.register(user)

        if registration.errors.none?
          if registration.previously_new_record?
            message = Messages::RegistrationCreateSuccess.render(registration)
          else
            message = Messages::RegistrationUpdateSuccess.render(registration)
          end
        else
          message = Messages::RegistrationUpsertFailure.render(registration)
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
