# frozen_string_literal: true

module Discord
  module Components
    class SelectMenu < DiscordObject
      attribute :type, T::Params::Integer.enum(
        ComponentType::STRING_SELECT,
        ComponentType::USER_SELECT,
        ComponentType::CHANNEL_SELECT,
        ComponentType::ROLE_SELECT,
        ComponentType::MENTIONABLE_SELECT
      )
      attribute :custom_id, T::Params::String
      attribute? :options, T::Params::Array.of(SelectOption)
      attribute? :channel_types, T::Params::Array.of(Integer)
      attribute? :placeholder, T::Params::String
      attribute? :default_values, T::Params::Array do
        attribute :id, T::Params::Integer
        attribute :type, T::Params::String.enum(
          'user', 'role', 'channel'
        )
      end
      attribute? :min_values, T::Params::Integer
      attribute? :max_values, T::Params::Integer
      attribute? :disabled, T::Params::Bool
    end
  end
end
