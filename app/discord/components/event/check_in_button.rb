# frozen_string_literal: true

module Components
  module Event
    class CheckInButton < Button
      # @param event [Event]
      def initialize(event)
        super()

        @event = event
      end

      label 'Check In'
      record_for_interaction { @event }

      class InteractionHandler < InteractionHandler
        # @!attribute [r] event
        #   @return [::Event]
        alias event record

        # @return [Discord::Interaction::Response]
        def interact
          if event.check_in(player)
            message = Messages::CheckInSuccess.render(event)
          else
            message = Messages::CheckInFailure.render(event)
          end

          Discord::Interaction::Response.channel_message(message)
        end

      private

        # @return [User]
        def player
          @player ||= User.upsert_from_discord!(request.member.user || request.user)
        end
      end
    end
  end
end
