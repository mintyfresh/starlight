# frozen_string_literal: true

class Event
  class DeleteAnnouncementMessageSubscriber < ApplicationSubscriber
    subscribes_to Event::AnnouncementConfig::DestroyMessage do |message|
      message.event_announcement_config.discord_message_id.present?
    end

    def perform
      Discord::Client.bot.delete_message(
        message.event_announcement_config.discord_channel_id,
        message.event_announcement_config.discord_message_id
      )
    end
  end
end
