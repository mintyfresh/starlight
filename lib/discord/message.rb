# frozen_string_literal: true

module Discord
  class Message < DiscordObject
    attribute? :id, T::Params::Integer.optional
    attribute? :channel_id, T::Params::Integer.optional
    attribute? :author, User.optional
    attribute? :content, T::Params::String
    attribute? :timestamp, T::Params::DateTime
    attribute? :edited_timestamp, T::Params::DateTime.optional
    attribute? :tts, T::Params::Bool
    attribute? :allowed_mentions do
      attribute? :parse, T::Params::Array.of(T::Params::String)
      attribute? :roles, T::Params::Array.of(T::Params::Integer)
      attribute? :users, T::Params::Array.of(T::Params::Integer)
      attribute? :replied_user, T::Params::Bool
    end
    attribute? :mention_everyone, T::Params::Bool
    attribute? :mentions, T::Params::Array.of(User)
    attribute? :mention_roles, T::Params::Array
    attribute? :mention_channels, T::Params::Array
    attribute? :attachments, T::Params::Array
    attribute? :embeds, T::Params::Array
    attribute? :reactions, T::Params::Array
    attribute? :nonce, T::Params::Integer | T::Params::String
    attribute? :pinned, T::Params::Bool
    attribute? :webhook_id, T::Params::Integer
    attribute? :type, T::Params::Integer
    attribute? :activity do
      attribute :type, T::Params::Integer
      attribute :party_id, T::Params::String
    end
    attribute? :application, T::Params::Hash
    attribute? :application_id, T::Params::Integer
    attribute? :message_reference do
      attribute? :message_id, T::Params::Integer.optional
      attribute? :channel_id, T::Params::Integer.optional
      attribute? :guild_id, T::Params::Integer.optional
      attribute? :fail_if_not_exists, T::Params::Bool.optional
    end
    attribute? :flags, T::Params::Integer
    attribute? :referenced_message, T::Params::Hash.optional
    attribute? :interaction, T::Params::Hash
    attribute? :thread, T::Params::Hash
    attribute? :components, T::Params::Array
    attribute? :sticker_items, T::Params::Array
    attribute? :stickers, T::Params::Array
    attribute? :position, T::Params::Integer
    attribute? :role_subscription_data, T::Params::Hash
    attribute? :resolved, T::Params::Hash

    # @param flag [Integer]
    # @return [Boolean]
    def flag?(flag)
      (flags || 0) & flag == flag
    end
  end
end
