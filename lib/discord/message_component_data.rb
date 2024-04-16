# frozen_string_literal: true

module Discord
  class MessageComponentData < DiscordObject
    schema schema.strict

    attribute :custom_id, T::Params::String
    attribute :component_type, T::Params::Integer
    attribute? :values, T::Params::Array do
      attribute :label, T::Params::String
      attribute :value, T::Params::String
      attribute? :description, T::Params::String
      attribute? :emoji, T::Params::Hash
      attribute? :default, T::Params::Bool
    end
    attribute? :resolved, ResolvedData
  end
end
