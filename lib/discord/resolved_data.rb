# frozen_string_literal: true

module Discord
  class ResolvedData < DiscordObject
    attribute? :users, T::Hash.map(T::Params::Integer, User).optional
    attribute? :members, T::Hash.map(T::Params::Integer, GuildMember).optional
    attribute? :roles, T::Hash.map(T::Params::Integer, T::Params::Hash).optional
    attribute? :channels, T::Hash.map(T::Params::Integer, Channel).optional
    attribute? :messages, T::Hash.map(T::Params::Integer, Message).optional
    attribute? :attachments, T::Hash.map(T::Params::Integer, T::Params::Hash).optional
  end
end
