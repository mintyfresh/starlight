# frozen_string_literal: true

module Discord
  module ApplicationCommandOptionType
    extend DiscordEnum

    # @type [Integer]
    SUB_COMMAND = 1
    # @type [Integer]
    SUB_COMMAND_GROUP = 2
    # @type [Integer]
    STRING = 3
    # Any integer between -2^53 and 2^53
    #
    # @type [Integer]
    INTEGER = 4
    # @type [Integer]
    BOOLEAN = 5
    # @type [Integer]
    USER = 6
    # Includes all channel types + categories
    #
    # @type [Integer]
    CHANNEL = 7
    # @type [Integer]
    ROLE = 8
    # Includes users and roles
    #
    # @type [Integer]
    MENTIONABLE = 9
    # Any double between -2^53 and 2^53
    #
    # @type [Integer]
    NUMBER = 10
    # Attachment object
    #
    # @type [Integer]
    ATTACHMENT = 11
  end
end
