# frozen_string_literal: true

module Discord
  class User < DiscordObject
    # @!attribute [r] id
    #   @return [Integer] the user's id
    attribute :id, T::Params::Integer
    # @!attribute [r] username
    #   @return [String] the user's username
    attribute :username, T::Params::String
    # @!attribute [r] discriminator
    #   @return [String] the user's discriminator
    attribute? :discriminator, T::Params::String
    # @!attribute [r] global_name
    #   @return [String] the user's global display name
    attribute? :global_name, T::Params::String.optional
    attribute :avatar, T::Params::String.optional
    attribute? :bot, T::Params::Bool
    attribute? :system, T::Params::Bool
    attribute? :mfa_enabled, T::Params::Bool
    attribute? :locale, T::Params::String.optional
    attribute? :accent_color, T::Params::Integer.optional
    attribute? :verified, T::Params::Bool
    attribute? :email, T::Params::String.optional
    attribute? :flags, T::Params::Integer
    attribute? :premium_type, T::Params::Integer
    attribute? :public_flags, T::Params::Integer
    attribute? :banner, T::Params::String.optional
  end
end
