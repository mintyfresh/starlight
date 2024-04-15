# frozen_string_literal: true

module Discord
  class ApplicationCommand < DiscordObject
    attribute? :id, T::Params::Integer
    attribute? :type, T::Params::Integer
    attribute? :application_id, T::Params::Integer
    attribute? :guild_id, T::Params::Integer
    attribute? :name, T::Params::String
    attribute? :name_localizations, T::LocalizationsMap
    attribute? :description, T::Params::String
    attribute? :description_localizations, T::LocalizationsMap
    attribute? :options, T::Params::Array.of(ApplicationCommandOption)
    attribute? :default_member_permissions, T::Params::String.optional
    attribute? :dm_permission, T::Params::Bool
    attribute? :default_permission, T::Params::Bool.optional
    attribute? :nsfw, T::Params::Bool
    attribute? :version, T::Params::Integer
  end
end
