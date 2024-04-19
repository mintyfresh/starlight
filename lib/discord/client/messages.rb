# frozen_string_literal: true

module Discord
  class Client
    module Messages
      # @param channel_id [Integer] The ID of the channel to send the message in
      # @param message [Discord::Message, Hash] The message to send
      # @return [Discord::Message]
      # @see https://discord.com/developers/docs/resources/channel#create-message
      def create_message(channel_id, message)
        post Discord::Message, "channels/#{channel_id}/messages", message
      end

      # @param channel_id [Integer] the ID of the channel to send the message in
      # @param message_id [Integer] the ID of the message to edit
      # @param message [Discord::Message, Hash] the updated message content
      # @return [Discord::Message]
      def update_message(channel_id, message_id, message)
        patch Discord::Message, "channels/#{channel_id}/messages/#{message_id}", message
      end

      # @param channel_id [Integer] the ID of the channel to send the message in
      # @param message_id [Integer] the ID of the message to delete
      # @return [true]
      def delete_message(channel_id, message_id)
        delete "channels/#{channel_id}/messages/#{message_id}"
      end
    end
  end
end
