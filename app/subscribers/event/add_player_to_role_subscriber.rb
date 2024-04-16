# frozen_string_literal: true

class Event
  class AddPlayerToRoleSubscriber < ApplicationSubscriber
    subscribes_to Registration::CreateMessage do |message|
      # check that the event has a role to add the player to
      message.registration.event.role_config&.discord_role_id.present?
    end

    def perform
      Discord::Client.bot.add_guild_member_role(
        message.registration.event.discord_guild_id,
        user_id: message.registration.player.discord_user_id,
        role_id: message.registration.event.role_config.discord_role_id
      )
    end
  end
end
