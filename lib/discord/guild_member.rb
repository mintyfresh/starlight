# frozen_string_literal: true

module Discord
  class GuildMember < DiscordObject
    attribute? :user, User
    attribute? :nick, T::Params::String.optional
    attribute? :avatar, T::Params::String.optional
    attribute :roles, T::Params::Array.of(T::Params::Integer)
    attribute :joined_at, T::Params::DateTime
    attribute? :premium_since, T::Params::DateTime.optional
    attribute :deaf, T::Params::Bool
    attribute :mute, T::Params::Bool
    attribute? :flags, T::Params::Integer
    attribute? :pending, T::Params::Bool
    attribute? :permissions, T::Params::String
    attribute? :communications_disabled_until, T::Params::DateTime.optional

    # @param flag [Integer]
    # @return [Boolean]
    def flag?(flag)
      (flags || 0) & flag == flag
    end
  end
end
