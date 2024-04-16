# frozen_string_literal: true

module Discord
  class ApplicationCommandInteractionDataOption < DiscordObject
    # @!attribute [r] name
    #   @return [String] the name of the parameter
    attribute :name, T::Params::String
    # @!attribute [r] type
    #   @return [Integer] value of the application command option type
    attribute :type, T::Params::Integer
    # @!attribute [r] value
    #   @return [Boolean, Integer, Float, String, nil] value of the option resulting from user input
    attribute? :value, T::Params::Bool | T::Params::Integer | T::Params::Float | T::Params::String
    # @!attribute [r] options
    #   @return [Array<Option>, nil] present if this option is a group or subcommand
    attribute? :options, T::Params::Array.of(ApplicationCommandInteractionDataOption)
    # @!attribute [r] focused
    #   @return [Boolean, nil] true if this option is the current focused option for autocomplete
    attribute? :focused, T::Params::Bool
  end
end
