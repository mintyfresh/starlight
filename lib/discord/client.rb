# frozen_string_literal: true

module Discord
  class Client
    API_VERSION = 10
    API_PREFIX  = "https://discord.com/api/v#{API_VERSION}".freeze

    include Roles

    # @param token [String] the Discord bot token
    def initialize(token = ENV.fetch('DISCORD_BOT_TOKEN', nil))
      token.present? or
        raise ArgumentError, 'token is required'

      @client = Faraday.new(API_PREFIX) do |conn|
        conn.request :authorization, 'Bot', token
        conn.request :json

        conn.response :raise_error
        conn.response :json
      end
    end

    # @return [Discord::User]
    def me
      Discord::User.new(@client.get('users/@me').body)
    end

    # Returns a list of channels in the guild.
    #
    # @param guild_id [Integer]
    # @return [Array<Discord::Channel>]
    def channels(guild_id)
      @client.get("guilds/#{guild_id}/channels").body.map do |channel|
        Discord::Channel.new(channel)
      end
    end
  end
end
