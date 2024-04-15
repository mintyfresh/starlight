# frozen_string_literal: true

module Commands
  class CreateEvent < Base
    description 'Creates a new event in a draft state'

    option :name, :string, 'The name of the event', required: true, max_length: Event::NAME_MAX_LENGTH

    # @return [Discord::Interaction::Response]
    def call
      Discord::Interaction::Response.channel_message(
        content: 'Test', flags: Discord::MessageFlags::EPHEMERAL
      )
    end
  end
end
