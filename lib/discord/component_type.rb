# frozen_string_literal: true

module Discord
  module ComponentType
    extend DiscordEnum

    # Container for other components.
    #
    # @type [Integer]
    ACTION_ROW = 1
    # Button object.
    #
    # @type [Integer]
    BUTTON = 2
    # Select menu for picking defined text options.
    #
    # @type [Integer]
    STRING_SELECT = 3
    # Text input object.
    #
    # @type [Integer]
    TEXT_INPUT = 4
    # Select menu for users.
    #
    # @type [Integer]
    USER_SELECT = 5
    # Select menu for roles.
    #
    # @type [Integer]
    ROLE_SELECT = 6
    # Select menu for mentionables (users and roles).
    #
    # @type [Integer]
    MENTIONABLE_SELECT = 7
    # Select menu for channels.
    #
    # @type [Integer]
    CHANNEL_SELECT = 8
  end
end
