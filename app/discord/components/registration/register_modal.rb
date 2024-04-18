# frozen_string_literal: true

module Components
  module Registration
    class RegisterModal < Modal
      # @param request [Discord::Interaction::Request]
      # @param event [Event]
      # @param attributes [Hash{String => String}]
      # @return [Discord::Interaction::Response]
      on_submit do |request, event, attributes|
        user = request.member.user || request.user
        user = User.upsert_from_discord!(user)

        registration = event.registrations.create_with(created_by: user).find_or_initialize_by(player: user)

        if registration.update(decklist_attributes: attributes)
          message = Messages::RegistrationCreateSuccess.render(registration)
        else
          message = Messages::RegistrationUpsertFailure.render(registration)
        end

        Discord::Interaction::Response.channel_message(message)
      end

      title do
        "Register for #{@registration.event.name}".truncate(45)
      end

      text_input :deck_name, Decklist.human_attribute_name(:deck_name), required: false do
        {
          value: @registration.decklist&.deck_name
        }.compact
      end
      text_input :ponyhead_url, Decklist.human_attribute_name(:ponyhead_url) do
        {
          required: @registration.event.decklist_required?,
          value:    @registration.decklist&.ponyhead_url
        }.compact
      end

      # @param registration [Registration]
      def initialize(registration)
        super()

        @registration = registration
      end

      # @return [String]
      def custom_id
        Components.encode_custom_id(self, @registration.event)
      end
    end
  end
end
