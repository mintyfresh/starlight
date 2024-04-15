# frozen_string_literal: true

module DiscordWebMocks
  DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze

  def stub_discord_api_request(method, path, **)
    stub_request(method, "#{Discord::Client::API_PREFIX}/#{path}")
      .with(headers: DEFAULT_HEADERS)
  end

  # @param channel_id [Integer]
  # @see Discord::Client#create_message
  def stub_discord_create_message(channel_id:, **)
    stub_discord_api_request(:post, "channels/#{channel_id}/messages")
      .with(body: hash_including(**))
      .to_return do |request|
        body = JSON.parse(request.body)

        response = {
          headers: DEFAULT_HEADERS, body: build_mock_discord_api_message(
            channel_id:, **body.slice('content', 'embeds', 'components').symbolize_keys
          )
        }

        yield(request, response) if block_given?
        response[:body] = response[:body].to_json if response[:body].is_a?(Hash)

        response
      end
  end

  # @param guild_id [Integer]
  # @param role [Discord::Role, Hash]
  # @see Discord::Client#create_guild_role
  def stub_discord_create_guild_role(guild_id, role = {})
    stub_discord_api_request(:post, "guilds/#{guild_id}/roles")
      .with(body: hash_including(role.to_h))
      .to_return do |request|
        body = JSON.parse(request.body)

        response = {
          headers: DEFAULT_HEADERS, body: build_mock_discord_api_guild_role(
            **body.slice('name', 'permissions', 'color', 'hoist', 'icon', 'unicode_emoji', 'mentionable').symbolize_keys
          )
        }

        yield(request, response) if block_given?
        response[:body] = response[:body].to_json if response[:body].is_a?(Hash)

        response
      end
  end

  # @param overrides [Hash]
  # @returm [Hash]
  def build_mock_discord_api_message(**overrides)
    {
      id:         Faker::Number.number(digits: 18),
      channel_id: Faker::Number.number(digits: 18),
      guild_id:   Faker::Number.number(digits: 18),
      content:    Faker::Lorem.sentence,
      timestamp:  Time.current.iso8601,
      **overrides
    }
  end

  # @param overrides [Hash]
  # @returm [Hash]
  def build_mock_discord_api_guild_role(**overrides)
    {
      id:            Faker::Number.number(digits: 18),
      name:          Faker::Lorem.word,
      color:         rand(0x000000..0xFFFFFF),
      hoist:         Faker::Boolean.boolean,
      icon:          nil,
      unicode_emoji: nil,
      position:      Faker::Number.number(digits: 2),
      permissions:   Faker::Number.number(digits: 8),
      managed:       Faker::Boolean.boolean,
      mentionable:   Faker::Boolean.boolean,
      tags:          nil,
      flags:         0,
      **overrides
    }
  end
end
