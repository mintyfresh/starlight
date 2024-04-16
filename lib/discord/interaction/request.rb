# frozen_string_literal: true

module Discord
  module Interaction
    class Request < DiscordObject
      # @!attribute [r] id
      #   @return [Integer] the id of the interaction
      attribute :id, T::Params::Integer
      # @!attribute [r] application_id
      #   @return [Integer] the id of the application this interaction is for
      attribute :application_id, T::Params::Integer
      # @!attribute [r] type
      #   @return [Integer] the type of interaction
      attribute :type, T::Params::Integer
      # @!attribute [r] data
      #   @return [ApplicationCommandData, MessageComponentData, ModalSubmitData, nil] the command data payload
      attribute? :data, RequestData.optional

      # @!attribute [r] token
      #   @return [String] a continuation token for responding to the interaction
      attribute :token, T::Params::String
      # @!attribute [r] version
      #   @return [Integer] read-only property, always 1
      attribute :version, T::Params::Integer

      # @!attribute [r] guild_id
      #   @return [Integer, nil] the guild this interaction was sent from
      attribute? :guild_id, T::Params::Integer
      # @!attribute [r] channel_id
      #   @return [Integer, nil] the channel this interaction was sent from
      attribute? :channel_id, T::Params::Integer
      # @!attribute [r] channel
      #   @return [Channel, nil] the channel this interaction was sent from
      attribute? :channel, Channel
      # @!attribute [r] member
      #   @return [GuildMember, nil] the guild member who invoked the interaction
      attribute? :member, GuildMember
      # @!attribute [r] user
      #   @return [User, nil] the user who invoked the interaction (if invoked from a DM)
      attribute? :user, User
      # @!attribute [r] message
      #   @return [Message, nil] for components, the message they were attached to
      attribute? :message, Message

      # @!attribute [r] app_permissions
      #   @return [String, nil] bitwise set of permissions the app or bot has within
      #                         the channel the interaction was sent from
      attribute? :app_permissions, T::Params::String
      # @!attribute [r] locale
      #   @return [String, nil] selected language of the invoking user
      attribute? :locale, T::Params::String
      # @!attribute [r] guild_locale
      #   @return [String, nil] guild's preferred locale, if invoked in a guild
      attribute? :guild_locale, T::Params::String
      # @!attribute [r] entitlements
      #   @return [Array, nil] for monetized apps, any entitlments for the invoking user,
      #                        representing access to premium SKUs
      attribute? :entitlements, T::Params::Array
    end
  end
end
