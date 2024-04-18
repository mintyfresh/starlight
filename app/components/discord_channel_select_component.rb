# frozen_string_literal: true

class DiscordChannelSelectComponent < ApplicationComponent
  renders_one :message_on_empty

  # @param name [String]
  # @param guild_id [Integer]
  # @param channel_types [Array<Integer>, nil]
  # @param selected [Integer, nil]
  # @param html_options [Hash]
  def initialize(name:, guild_id:, channel_types: nil, selected: nil, **html_options)
    super()

    @name          = name
    @guild_id      = guild_id
    @channel_types = channel_types
    @selected      = selected
    @html_options  = html_options
  end

  # @return [Array<(String, Integer)>]
  def channel_options
    @channel_options ||= discord_channels.filter_map do |channel|
      next unless include_channel_in_options?(channel)

      name = channel.name

      if channel.parent_id && (parent = discord_channels.find { |c| c.id == channel.parent_id })
        name = "#{parent.name} > #{name}"
      end

      [name, channel.id]
    end
  end

  # @param channel [Discord::Channel]
  # @return [Boolean]
  def include_channel_in_options?(channel)
    @channel_types.nil? || channel.type.in?(@channel_types)
  end

private

  # @return [Array<Discord::Channel>]
  def discord_channels
    RequestStore.store[discord_channels_cache_key] ||= Discord::Client.bot.channels(@guild_id)
  end

  # @return [String]
  def discord_channels_cache_key
    "discord_channels:#{@guild_id}"
  end
end
