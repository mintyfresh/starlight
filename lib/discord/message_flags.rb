# frozen_string_literal: true

module Discord
  module MessageFlags
    extend DiscordEnum

    # @type [Integer]
    CROSSPOSTED = 1 << 0
    # @type [Integer]
    IS_CROSSPOST = 1 << 1
    # @type [Integer]
    SUPPRESS_EMBEDS = 1 << 2
    # @type [Integer]
    SOURCE_MESSAGE_DELETED = 1 << 3
    # @type [Integer]
    URGENT = 1 << 4
    # @type [Integer]
    HAS_THREADS = 1 << 5
    # @type [Integer]
    EPHEMERAL = 1 << 6
    # @type [Integer]
    LOADING = 1 << 7
    # @type [Integer]
    FAILED_TO_MENTION_SOME_ROLES_IN_THREAD = 1 << 8
    # @type [Integer]
    SUPPRESS_NOTIFICATIONS = 1 << 12
    # @type [Integer]
    IS_VOICE_THREAD = 1 << 13
  end
end
