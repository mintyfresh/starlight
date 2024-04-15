# frozen_string_literal: true

module Discord
  class ApplicationCommandInteractionDataOption < DiscordObject
    attribute? :name, T::Params::String
    attribute? :type, T::Params::Integer
    attribute? :value, T::Params::Integer | T::Params::Float | T::Params::Bool | T::Params::String
    attribute? :options, T::Params::Array.of(ApplicationCommandInteractionDataOption).optional
    attribute? :focused, T::Params::Bool.optional
  end
end
