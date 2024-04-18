# frozen_string_literal: true

module Components
  module Event
    class RegisterButton < Button
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

      class InteractionHandler < InteractionHandler
        # @!attribute [r] event
        #   @return [::Event]
        alias event record

        # @return [Discord::Interaction::Response]
        def interact
          # display a modal to collect the user's decklist if the event supports one
          return render_registration_modal if event.decklist_permitted?

          registration = event.register(player)

          if registration.errors.any?
            message = Messages::RegistrationUpsertFailure.render(registration)
          elsif registration.previously_new_record?
            message = Messages::RegistrationCreateSuccess.render(registration)
          else
            message = Messages::RegistrationUpdateSuccess.render(registration)
          end

          Discord::Interaction::Response.channel_message(message)
        end

      private

        # @return [Discord::Interaction::Response]
        def render_registration_modal
          registration = event.registrations.find_or_initialize_by(player:)
          Modals::RegistrationModal.render(registration)
        end

        # @return [User]
        def player
          @player ||= User.upsert_from_discord!(request.member.user || request.user)
        end
      end
    end
  end
end
