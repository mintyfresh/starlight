# frozen_string_literal: true

module Discord
  class ApplicationCommandData < DiscordObject
    schema schema.strict

    # @!attribute [r] id
    #   @return [Integer] the id of the command
    attribute :id, T::Params::Integer
    # @!attribute [r] name
    #   @return [String] the name of the command
    attribute :name, T::Params::String
    # @!attribute [r] type
    #   @return [Integer] the type of the command
    attribute :type, T::Params::Integer
    # @!attribute [r] resolved
    #   @return [ResolvedData, nil] converted users + roles + channels + attachments
    attribute? :resolved, ResolvedData
    # @!attribute [r] options
    #   @return [Array, nil] the params + values from the user
    attribute? :options, T::Params::Array.of(ApplicationCommandInteractionDataOption)
    # @!attribute [r] guild_id
    #   @return [Integer, nil] the id of the guild the command is registered to
    attribute? :guild_id, T::Params::Integer
    # @!attribute [r] target_id
    #   @return [Integer, nil] the id of the user or message targetted by a user or message command
    attribute? :target_id, T::Params::Integer
  end
end
