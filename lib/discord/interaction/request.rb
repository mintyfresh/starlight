# frozen_string_literal: true

module Discord
  module Interaction
    class Request < DiscordObject
      class ApplicationCommandData < DiscordObject
        schema schema.strict

        attribute :id, T::Params::Integer
        attribute :name, T::Params::String
        attribute :type, T::Params::Integer
        attribute? :resolved, ResolvedData
        attribute? :options, T::Params::Array.of(ApplicationCommandInteractionDataOption)
        attribute? :guild_id, T::Params::Integer
        attribute? :target_id, T::Params::Integer
      end

      class MessageComponentData < DiscordObject
        schema schema.strict

        attribute :custom_id, T::Params::String
        attribute :component_type, T::Params::Integer
        attribute? :values, T::Params::Array do
          attribute :label, T::Params::String
          attribute :value, T::Params::String
          attribute? :description, T::Params::String
          attribute? :emoji, T::Params::Hash
          attribute? :default, T::Params::Bool
        end
        attribute? :resolved, ResolvedData
      end

      class ModalSubmitData < DiscordObject
        schema schema.strict

        attribute :custom_id, T::Params::String
        attribute :components, T::Params::Array.of(Component)
      end

      RequestData = ApplicationCommandData |
                    MessageComponentData |
                    ModalSubmitData

      attribute :id, T::Params::Integer
      attribute :application_id, T::Params::Integer
      attribute :type, T::Params::Integer
      attribute? :data, RequestData.optional

      attribute :token, T::Params::String
      attribute :version, T::Params::Integer

      attribute? :guild_id, T::Params::Integer
      attribute? :channel_id, T::Params::Integer
      attribute? :channel, Channel
      attribute? :member, GuildMember
      attribute? :user, User
      attribute? :message, Message

      attribute? :app_permissions, T::Params::String
      attribute? :locale, T::Params::String
      attribute? :guild_locale, T::Params::String
      attribute? :entitlements, T::Params::Array
    end
  end
end
