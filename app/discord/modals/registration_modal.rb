# frozen_string_literal: true

module Modals
  class RegistrationModal < Base
    # @param registration [Registration]
    def initialize(registration)
      super()

      @registration = registration
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

    record_for_submit do
      @registration.event # the registration itself might not be persisted yet
    end

    class SubmitHandler < SubmitHandler
      alias event record

      def submit
        if registration.update(decklist_attributes: attributes)
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

    private

      # @return [Registration]
      def registration
        @registration ||= event.registrations.create_with(created_by: user).find_or_initialize_by(player: user)
      end

      # @return [User]
      def user
        @user ||= User.upsert_from_discord!(request.member.user || request.user)
      end
    end
  end
end
