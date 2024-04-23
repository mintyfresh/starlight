# frozen_string_literal: true

module Messages
  class EventCheckIn < Base
    # @param event [Event]
    def initialize(event)
      super()

      @event = event
    end

    # @return [Discord::Message]
    def render
      Discord::Message.new(
        content:, allowed_mentions:, message_reference:, components: [action_row]
      )
    end

  private

    # @return [String]
    def content
      if discord_role_id.present?
        mention = "<@&#{discord_role_id}>"
      else
        mention = @event.registered_players.map { |player| "<@#{player.discord_user_id}>" }.join(' ')
      end

      check_in_closes_at = @event.check_in_config.ends_at || @event.starts_at

      <<~CONTENT
        Hey there, #{mention}! #{@event.name} is now open for check-in.
        Check-in closes at #{I18n.l(check_in_closes_at, format: :long)}.
        Click the button below to check in. (You can also do so from the website.)
      CONTENT
    end

    # @return [Discord::Message::AllowedMentions]
    def allowed_mentions
      if discord_role_id.present?
        Discord::Message::AllowedMentions.new(roles: [discord_role_id])
      else
        Discord::Message::AllowedMentions.new(users: @event.registered_players.pluck(:discord_user_id))
      end
    end

    # @return [Integer, nil]
    def discord_role_id
      @event.role_config.discord_role_id if @event.role_config.present? && @event.role_config.mentionable?
    end

    # Creates a message reference to event announcement message.
    # If no announcement message exists, the check-in message will not be a reply.
    #
    # @return [Discord::Message::MessageReference, nil]
    def message_reference
      return if @event.announcement_config.nil? || @event.announcement_config.discord_message_id.nil?

      Discord::Message::MessageReference.new(
        message_id:         @event.announcement_config.discord_message_id,
        channel_id:         @event.announcement_config.discord_channel_id,
        guild_id:           @event.discord_guild_id,
        fail_if_not_exists: false
      )
    end

    # @return [Discord::Components::ActionRow]
    def action_row
      Discord::Components::ActionRow.new(
        components: [check_in_button, view_event_button]
      )
    end

    # @return [Discord::Components::Button]
    def check_in_button
      Components::Event::CheckInButton.render(@event)
    end

    # @return [Discord::Components::Button]
    def view_event_button
      Components::Event::ViewOnlineButton.render(@event)
    end
  end
end
