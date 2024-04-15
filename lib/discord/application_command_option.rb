# frozen_string_literal: true

module Discord
  class ApplicationCommandOption < DiscordObject
    attribute? :type, T::Params::Integer
    attribute? :name, T::Params::String
    attribute? :name_localizations, T::LocalizationsMap.optional
    attribute? :description, T::Params::String
    attribute? :description_localizations, T::LocalizationsMap.optional
    attribute? :required, T::Params::Bool
    attribute? :choices, T::Params::Array do
      attribute :name, T::Params::String
      attribute? :name_localizations, T::LocalizationsMap.optional
      attribute :value, T::Params::Integer | T::Params::Float | T::Params::String
    end
    attribute? :options, T::Params::Array.of(self)
    attribute? :channel_types, T::Params::Array.of(T::Params::Integer)
    attribute? :min_value, T::Params::Integer | T::Params::Float
    attribute? :max_value, T::Params::Integer | T::Params::Float
    attribute? :min_length, T::Params::Integer
    attribute? :max_length, T::Params::Integer
    attribute? :autocomplete, T::Params::Bool
  end
end
