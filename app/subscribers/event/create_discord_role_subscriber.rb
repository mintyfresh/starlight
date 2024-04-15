# frozen_string_literal: true

class Event
  class CreateDiscordRoleSubscriber < ApplicationSubscriber
    subscribes_to EventRoleConfig::CreateMessage do |message|
      # only create roles for published events
      message.event_role_config.event.published?
    end

    subscribes_to Event::PublishMessage do |message|
      # role configuration required to create a role
      message.event.role_config.present?
    end

    def perform
      client = Discord::Client.bot

      role = client.create_guild_role(event.discord_guild_id, role_config.discord_role_attributes)
      role_config.update!(discord_role_id: role.id)
    end

  private

    # @return [Event]
    def event
      case message
      when EventRoleConfig::CreateMessage
        message.event_role_config.event
      when Event::PublishMessage
        message.event
      else
        raise TypeError, "Unexpected message type: #{message.class}"
      end
    end

    # @return [EventRoleConfig]
    def role_config
      case message
      when EventRoleConfig::CreateMessage
        message.event_role_config
      when Event::PublishMessage
        message.event.role_config
      else
        raise TypeError, "Unexpected message type: #{message.class}"
      end
    end
  end
end
