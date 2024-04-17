# frozen_string_literal: true

module Commands
  class CreateEvent < Base
    description 'Creates a new event in a draft state'

    option :type, :string, 'The type of event', required: true, choices: [
      { name: 'Constructed', value: ConstructedEvent.sti_name }
    ]

    option :name, :string, 'The name of the event', required: true, max_length: Event::NAME_MAX_LENGTH

    # @return [Discord::Interaction::Response]
    def call
      event = Event.new(event_params)

      if event.save
        render_message Messages::EventCreateSuccess, event
      else
        render_message Messages::EventCreateFailure, event
      end
    end

  private

    # @return [Hash]
    def event_params
      options_as_hash.merge(created_by: current_user, discord_guild_id:)
    end

    # @return [Integer]
    def discord_guild_id
      request.guild_id || request.data.guild_id
    end

    # @return [User]
    def current_user
      @current_user ||= User.upsert_from_discord!(request.member.user || request.user)
    end
  end
end
