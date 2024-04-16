# frozen_string_literal: true

module Discord
  module Interaction
    class Response < DiscordObject
      class AutocompleteResponseData < DiscordObject
        attribute :choices, T::Array do
          attribute :name, T::Coercible::String
          attribute? :name_localizations, T::Hash.map(T::Coercible::String, T::Coercible::String)
          attribute :value, T::Coercible::String | T::Coercible::Integer | T::Coercible::Float
        end
      end

      class MessageResponseData < DiscordObject
        attribute? :tts, T::Bool
        attribute? :content, T::Coercible::String
        attribute? :embeds, T::Coercible::Array
        attribute? :flags, T::Coercible::Integer
        attribute? :components, T::Coercible::Array.of(Discord::Component)
        attribute? :attachments, T::Coercible::Array
      end

      class ModalResponseData < DiscordObject
        attribute :custom_id, T::Coercible::String
        attribute :title, T::Coercible::String
        attribute :components, T::Coercible::Array
      end

      # Uses `Instance` type to prevent coercion
      ResponseData = T::Instance(AutocompleteResponseData) |
                     T::Instance(MessageResponseData) |
                     T::Instance(ModalResponseData)

      # @!attribute [r] type
      #   The type of response
      #   @return [Integer]
      attribute :type, T::Integer.enum(*ResponseType.all)
      # @!attribute [r] data
      #   The data to send with the response
      #   @return [ResponseData, nil]
      attribute? :data, T::Nil | ResponseData

      # @return [Response]
      def self.pong
        new(type: ResponseType::PONG)
      end

      # @param data [AutocompleteResponseData, Hash]
      # @return [Response]
      def self.autocomplete_result(data)
        type = ResponseType::APPLICATION_COMMAND_AUTOCOMPLETE_RESULT
        data = AutocompleteResponseData.new(data)

        new(type:, data:)
      end

      # @param data [MessageResponseData, Hash]
      # @return [Response]
      def self.channel_message(data)
        type = ResponseType::CHANNEL_MESSAGE_WITH_SOURCE
        data = MessageResponseData.new(data)

        new(type:, data:)
      end

      # @return [Response]
      def self.deferred_channel_message
        new(type: ResponseType::DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE)
      end

      # @return [Response]
      def self.deferred_update_message
        new(type: ResponseType::DEFERRED_UPDATE_MESSAGE)
      end

      # @param data [MessageResponseData, Hash]
      # @return [Response]
      def self.update_message(data)
        type = ResponseType::UPDATE_MESSAGE
        data = MessageResponseData.new(data)

        new(type:, data:)
      end

      # @param data [ModalResponseData, Hash]
      # @return [Response]
      def self.modal(data)
        type = ResponseType::MODAL
        data = ModalResponseData.new(data)

        new(type:, data:)
      end
    end
  end
end
