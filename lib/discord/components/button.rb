# frozen_string_literal: true

module Discord
  module Components
    class Button < DiscordObject
      attribute :type, T::Params::Integer.constrained(eql: ComponentType::BUTTON).default(ComponentType::BUTTON)
      attribute :style, T::Params::Integer
      attribute? :label, T::Params::String
      attribute? :emoji, T::Params::Hash
      attribute? :custom_id, T::Params::String
      attribute? :url, T::Params::String
      attribute? :disabled, T::Params::Bool

      # @param label [String]
      # @param url [String]
      # @param options [Hash]
      # @return [Button]
      def self.link(label, url, **)
        new(**, label:, url:, style: ButtonStyle::LINK)
      end
    end
  end
end
