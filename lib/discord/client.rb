# frozen_string_literal: true

module Discord
  class Client
    API_VERSION = 10
    API_PREFIX  = "https://discord.com/api/v#{API_VERSION}".freeze

    include Commands
    include Roles

    # @param token [String] the Discord bot token
    # @return [Discord::Client]
    def self.bot(token = ENV.fetch('DISCORD_BOT_TOKEN'))
      new(token:, scheme: 'Bot')
    end

    # @param token [String] the User's access token
    # @return [Discord::Client]
    def self.user(token)
      new(token:, scheme: 'Bearer')
    end

    # @param token [String] the Discord bot token
    # @param scheme [String] the authorization scheme
    def initialize(token:, scheme:)
      token.present? or
        raise ArgumentError, 'token is required'

      @client = Faraday.new(API_PREFIX) do |conn|
        conn.request :authorization, scheme, token
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
