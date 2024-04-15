# frozen_string_literal: true

module Discord
  module ChannelType
    extend DiscordEnum

    # A text channel within a server.
    #
    # @type [Integer]
    GUILD_TEXT = 0
    # A direct message between users.
    #
    # @type [Integer]
    DM = 1
    # A voice channel within a server.
    #
    # @type [Integer]
    GUILD_VOICE = 2
    # A direct message between multiple users.
    #
    # @type [Integer]
    GROUP_DM = 3
    # An organizational category that contains up to 50 channels.
    #
    # @type [Integer]
    GUILD_CATEGORY = 4
    # A channel that users can follow and crosspost into their own server.
    # (Formerly "news" channels.)
    #
    # @type [Integer]
    GUILD_ANNOUNCEMENT = 5
    # A temporary sub-channel within a GUILD_ANNOUCEMENT channel.
    #
    # @type [Integer]
    ANNOUNCEMENT_THREAD = 10
    # A temporary sub-channel within a GUILD_TEXT or GUILD_FORUM channel.
    #
    # @type [Integer]
    PUBLIC_THREAD = 11
    # A temporary sub-channel within a GUILD_TEXT channel that is only viewable
    # by those invited and those with the MANAGE_THREADS permission.
    #
    # @type [Integer]
    PRIVATE_THREAD = 12
    # A voice channel for hosting events with an audience.
    #
    # @type [Integer]
    GUILD_STAGE_VOICE = 13
    # The channel in a hub containing the listed servers.
    #
    # @type [Integer]
    GUILD_DIRECTORY = 14
    # Channel that can only contain threads.
    #
    # @type [Integer]
    GUILD_FORUM = 15
    # Channel that can only contain threads, similar to GUILD_FORUM channels.
    #
    # @type [Integer]
    GUILD_NEWS = 16
  end
end
