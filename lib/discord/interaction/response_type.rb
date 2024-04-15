# frozen_string_literal: true

module Discord
  module Interaction
    module ResponseType
      extend DiscordEnum

      # ACK a Ping
      #
      # @type [Integer]
      # @see Discord::Interaction::PING
      PONG = 1
      # Respond to an interaction with a message
      #
      # @type [Integer]
      CHANNEL_MESSAGE_WITH_SOURCE = 4
      # ACK an interaction and edit a response later, the user sees a loading state
      #
      # @type [Integer]
      DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE = 5
      # For components, ACK an interaction and edit the original message later;
      # the user does not see a loading state
      #
      # @type [Integer]
      DEFERRED_UPDATE_MESSAGE = 6
      # For components, edit the message the component was attached to
      #
      # @type [Integer]
      UPDATE_MESSAGE = 7
      # Respond to an autocomplete interaction with suggestion choices
      #
      # @type [Integer]
      APPLICATION_COMMAND_AUTOCOMPLETE_RESULT = 8
      # Respond to an interaction with a popup modal
      #
      # @type [Integer]
      MODAL = 9
      # Respond to an interaction with an upgrade button,
      # only available for apps with monetization enabled
      #
      # @type [Integer]
      PREMIUM_REQUIRED = 10
    end
  end
end
