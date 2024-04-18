# frozen_string_literal: true

module Messages
  class RegistrationUpsertFailure < Base
    # @param registration [Registration]
    def initialize(registration)
      super()

      @registration = registration
    end

    # @return [Discord::Interaction::Response::MessageResponseData]
    def render
      Discord::Interaction::Response::MessageResponseData.new(
        content:, flags: Discord::MessageFlags::EPHEMERAL
      )
    end

  private

    # @return [String]
    def content
      [
        'Failed to register due to the following errors:',
        *@registration.errors.full_messages.map { |message| "- #{message}" }
      ].join("\n")
    end
  end
end
