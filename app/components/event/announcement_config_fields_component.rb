# frozen_string_literal: true

class Event
  class AnnouncementConfigFieldsComponent < ApplicationComponent
    SUPPORTED_CHANNEL_TYPES = [
      Discord::ChannelType::GUILD_TEXT,
      Discord::ChannelType::GUILD_ANNOUNCEMENT
    ].freeze

    # @param form [Bootstrap::FormBuilder]
    def initialize(form:)
      @form = form
    end

    # @return [Event::AnnouncementConfig]
    def announcement_config
      @form.object.announcement_config || Event::AnnouncementConfig.new
    end

    # @return [Array<(String, Integer)>]
    def channel_options
      discord_channels.filter_map do |channel|
        next unless channel.type.in?(SUPPORTED_CHANNEL_TYPES)

        name = channel.name

        if channel.parent_id && (parent = discord_channels.find { |c| c.id == channel.parent_id })
          name = "#{parent.name} > #{name}"
        end

        [name, channel.id]
      end
    end

  private

    # @return [Array<Discord::Channel>]
    def discord_channels
      @discord_channels ||= Discord::Client.bot.channels(@form.object.discord_guild_id)
    end
  end
end
