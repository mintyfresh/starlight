# frozen_string_literal: true

module Discord
  module ChannelFlags
    extend DiscordEnum

    # This thread is pinned to the top of its parent `GUILD_FORUM` or `GUILD_MEDIA` channel.
    #
    # @type [Integer]
    PINNED = 1 << 0

    # Whether a tag is required to be specified when creating a thread in a `GUILD_FORUM` or `GUILD_MEDIA` channel.
    # Tags are specified in the `applied_tags` field.
    #
    # @type [Integer]
    REQUIRE_TAG = 1 << 4

    # When set, hides the embedded media download options. Available only for media channels.
    #
    # @type [Integer]
    HIDE_MEDIA_DOWNLOAD_OPTIONS = 1 << 15
  end
end
