# frozen_string_literal: true

module Discord
  class ApplicationCommand < DiscordObject
    # @!attribute [r] id
    #   Unique ID of the command
    #   @return [Integer, nil]
    attribute? :id, T::Params::Integer
    # @!attribute [r] type
    #   The type of the command, defaults to 1
    #   @return [Integer, nil]
    #   @see Discord::ApplicationCommandType
    attribute? :type, T::Params::Integer
    # @!attribute [r] application_id
    #   ID of the parent application
    #   @return [Integer, nil]
    attribute? :application_id, T::Params::Integer
    # @!attribute [r] guild_id
    #   Guild ID of the command, if not global
    #   @return [Integer, nil]
    attribute? :guild_id, T::Params::Integer
    # @!attribute [r] name
    #   Name of the command, 1-32 characters
    #   @return [String, nil]
    attribute? :name, T::Params::String
    # @!attribute [r] name_localizations
    #   @return [Hash{String => String}, nil]
    attribute? :name_localizations, T::LocalizationsMap.optional
    # @!attribute [r] description
    #   Description for `CHAT_INPUT` commands, 1-100 characters.
    #   Empty string for `USER` and `MESSAGE` commands.
    #   @return [String, nil]
    attribute? :description, T::Params::String
    # @!attribute [r] description_localizations
    #   @return [Hash{String => String}, nil]
    attribute? :description_localizations, T::LocalizationsMap.optional
    # @!attribute [r] options
    #   Parameters for the command, max of 25
    #   @return [Array<Discord::ApplicationCommandOption>, nil]
    attribute? :options, T::Params::Array.of(ApplicationCommandOption)
    # @!attribute [r] default_permission
    #   Set of permissions represented as a bit set
    #   @return [String, nil]
    attribute? :default_member_permissions, T::Params::String.optional
    # @!attribute [r] dm_permission
    #   Indicates whether the command is available in DMs with the app, only for globally-scoped commands.
    #   By default, commands are visible.
    #   @return [Boolean, nil]
    #   @deprecated Use `contexts` instead
    attribute? :dm_permission, T::Params::Bool.optional
    # @!attribute [r] default_permission
    #   Not recommended for use as field will soon be deprecated.
    #   Indicates whether the command is enabled by default when the app is added to a guild, defaults to true.
    #   @return [Boolean, nil]
    attribute? :default_permission, T::Params::Bool.optional
    # @!attribute [r] nsfw
    #   Indicates whether the command is age-restricted, defaults to false.
    #   @return [Boolean, nil]
    attribute? :nsfw, T::Params::Bool.optional
    # @!attribute [r] version
    #   Auto-incrementing version identifier updated during significant changes
    #   @return [Integer, nil]
    attribute? :version, T::Params::Integer
  end
end
