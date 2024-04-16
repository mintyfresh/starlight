# frozen_string_literal: true

class Event
  class RemovePlayerFromRoleSubscriber < ApplicationSubscriber
    subscribes_to Registration::DestroyMessage do |message|
      # check that the event has a role to remove the player from
      message.registration.event.role_config&.discord_role_id.present?
    end

    def perform
      Discord::Client.bot.remove_guild_member_role(
        message.registration.event.discord_guild_id,
        user_id: message.registration.player.discord_user_id,
        role_id: message.registration.event.role_config.discord_role_id
      )
    end
  end
end
