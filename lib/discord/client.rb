# frozen_string_literal: true

module Discord
  class Client
    API_VERSION = 10
    API_PATH    = "/api/v#{API_VERSION}".freeze
    API_PREFIX  = "https://discord.com/#{API_PATH}".freeze

    include ActiveSupport::Benchmarkable
    include Commands
    include Messages
    include Roles

    # @!scope class
    # @!attribute [rw] logger
    #   @return [Logger] the logger to use
    cattr_accessor :logger, default: Rails.logger

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

    # @!method logger
    #   @return [Logger]
    delegate :logger, to: :class

    # @return [Discord::User]
    def me
      get Discord::User, 'users/@me'
    end

    # Returns a list of channels in the guild.
    #
    # @param guild_id [Integer]
    # @return [Array<Discord::Channel>]
    def channels(guild_id)
      get Discord::Channel, "guilds/#{guild_id}/channels"
    end

  private

    GET = 'Discord GET'.colorize(:blue).bold.freeze
    POST = 'Discord POST'.colorize(:green).bold.freeze
    PATCH = 'Discord PATCH'.colorize(:yellow).bold.freeze
    PUT = 'Discord PUT'.colorize(:magenta).bold.freeze
    DELETE = 'Discord DELETE'.colorize(:red).bold.freeze
    private_constant :GET, :POST, :PATCH, :PUT, :DELETE

    # @param klass [Class<Discord::Resource>]
    # @param resource [String]
    # @return [Discord::Resource, Array<Discord::Resource>]
    def get(klass, resource)
      benchmark GET, resource do
        result = @client.get(resource).body

        if result.is_a?(Array)
          result.map { |data| klass.new(data) }
        else
          klass.new(result)
        end
      end
    end

    # @param klass [Class<Discord::Resource>]
    # @param resource [String]
    # @param data [Discord::Resource, Hash]
    # @return [Discord::Resource]
    def post(klass, resource, data)
      benchmark POST, resource do
        klass.new(@client.post(resource, data.to_h).body)
      end
    end

    # @param klass [Class<Discord::Resource>]
    # @param resource [String]
    # @param data [Discord::Resource, Hash]
    # @return [Discord::Resource]
    def patch(klass, resource, data)
      benchmark PATCH, resource do
        klass.new(@client.patch(resource, data.to_h).body)
      end
    end

    # @param resource [String]
    # @return [true]
    def put(resource)
      benchmark PUT, resource do
        @client.put(resource).body
        true
      end
    end

    # @param resource [String]
    # @return [true]
    def delete(resource)
      benchmark DELETE, resource do
        @client.delete(resource)
        true
      end
    end

    # @param method [String]
    # @param path [String]
    def benchmark(method, path, &)
      super("  #{method} #{API_PATH}/#{path}", &)
    end
  end
end
