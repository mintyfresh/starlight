# frozen_string_literal: true

module Discord
  module Components
    class TextInput < DiscordObject
      schema schema.strict

      attribute :type, T::Params::Integer.constrained(eql: ComponentType::TEXT_INPUT).default(ComponentType::TEXT_INPUT)
      attribute :custom_id, T::Params::String
      attribute? :style, T::Params::Integer
      attribute? :label, T::Params::String
      attribute? :min_length, T::Params::Integer
      attribute? :max_length, T::Params::Integer
      attribute? :required, T::Params::Bool
      attribute? :value, T::Params::String.optional
      attribute? :placeholder, T::Params::String.optional
    end
  end
end
