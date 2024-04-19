# frozen_string_literal: true

class Event
  class CreateAnnouncementMessageSubscriber < ApplicationSubscriber
    # event with announcement configuration published
    subscribes_to Event::PublishMessage do |message|
      message.event.announcement_config.present? &&
        message.event.announcement_config.discord_message_id.blank?
    end

    # announcement configuration added to a published event
    subscribes_to Event::AnnouncementConfig::CreateMessage do |message|
      message.event_announcement_config.discord_message_id.blank? &&
        message.event_announcement_config.event.published?
    end

    def perform
      client = Discord::Client.bot

      discord_message = client.create_message(
        event_announcement_config.discord_channel_id,
        Messages::EventAnnouncement.render(event)
      )

      event_announcement_config.update!(discord_message_id: discord_message.id)
    end

  private

    # @return [Event]
    def event
      case message
      when Event::PublishMessage
        message.event
      when Event::AnnouncementConfig::CreateMessage
        message.event_announcement_config.event
      else
        raise TypeError, "Unexpected message type: #{message.class}"
      end
    end

    # @return [Event::AnnouncementConfig]
    def event_announcement_config
      case message
      when Event::PublishMessage
        message.event.announcement_config
      when Event::AnnouncementConfig::CreateMessage
        message.event_announcement_config
      else
        raise TypeError, "Unexpected message type: #{message.class}"
      end
    end
  end
end
