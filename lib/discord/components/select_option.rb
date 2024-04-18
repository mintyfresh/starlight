# frozen_string_literal: true

module Discord
  module Components
    class SelectOption < DiscordObject
      schema schema.strict

      attribute :label, T::Params::String
      attribute :value, T::Params::String
      attribute? :description, T::Params::String
      attribute? :emoji, T::Params::Hash
      attribute? :default, T::Params::Bool
    end
  end
end
