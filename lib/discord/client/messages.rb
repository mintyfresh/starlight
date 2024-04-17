# frozen_string_literal: true

module Discord
  class Client
    module Messages
      # @param channel_id [Integer] The ID of the channel to send the message in
      # @param message [Discord::Message, Hash] The message to send
      # @return [Discord::Message]
      # @see https://discord.com/developers/docs/resources/channel#create-message
      def create_message(channel_id, message)
        Discord::Message.new(@client.post("channels/#{channel_id}/messages", message.to_h).body)
      end
    end
  end
end
