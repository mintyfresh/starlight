# frozen_string_literal: true

module Discord
  module ApplicationCommandType
    extend DiscordEnum

    # Slash commands; a text-based command that shows up when a user types `/`.
    #
    # @type [Integer]
    CHAT_INPUT = 1
    # A UI-based command that shows up when you right click or tap on a user.
    #
    # @type [Integer]
    USER = 2
    # A UI-based command that shows up when you right click or tap on a message.
    #
    # @type [Integer]
    MESSAGE = 3
  end
end
