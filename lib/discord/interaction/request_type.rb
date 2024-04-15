# frozen_string_literal: true

module Discord
  module Interaction
    module RequestType
      extend DiscordEnum

      # @type [Integer]
      PING = 1
      # @type [Integer]
      APPLICATION_COMMAND = 2
      # @type [Integer]
      MESSAGE_COMPONENT = 3
      # @type [Integer]
      APPLICATION_COMMAND_AUTOCOMPLETE = 4
      # @type [Integer]
      MODAL_SUBMIT = 5
    end
  end
end
