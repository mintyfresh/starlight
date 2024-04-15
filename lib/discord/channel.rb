# frozen_string_literal: true

module Discord
  class Channel < DiscordObject
    attribute :id, T::Params::Integer
    attribute :type, T::Params::Integer
    attribute? :guild_id, T::Params::Integer
    attribute? :position, T::Params::Integer
    attribute? :permission_overwrites, T::Params::Array
    attribute? :name, T::Params::String.optional
    attribute? :topic, T::Params::String.optional
    attribute? :nsfw, T::Params::Bool
    attribute? :last_message_id, T::Params::Integer.optional
    attribute? :bitrate, T::Params::Integer
    attribute? :user_limit, T::Params::Integer
    attribute? :rate_limit_per_user, T::Params::Integer
    attribute? :recipients, T::Params::Array.of(User)
    attribute? :icon, T::Params::String.optional
    attribute? :owner_id, T::Params::Integer
    attribute? :application_id, T::Params::Integer
    attribute? :managed, T::Params::Bool
    attribute? :parent_id, T::Params::Integer.optional
    attribute? :last_pin_timestamp, T::Params::DateTime.optional
    attribute? :rtc_region, T::Params::String.optional
    attribute? :video_quality_mode, T::Params::Integer
    attribute? :message_count, T::Params::Integer
    attribute? :member_count, T::Params::Integer
    attribute? :thread_metadata, T::Params::Hash
    attribute? :member, T::Params::Hash
    attribute? :default_auto_archive_duration, T::Params::Integer
    attribute? :permissions, T::Params::String
    attribute? :flags, T::Params::Integer
    attribute? :total_message_sent, T::Params::Integer
    attribute? :available_tags, T::Params::Array
    attribute? :applied_tags, T::Params::Array
    attribute? :default_reaction_emoji, T::Params::Hash.optional
    attribute? :default_thread_rate_limit_per_user, T::Params::Integer
    attribute? :default_sort_order, T::Params::Integer.optional
    attribute? :default_form_layout, T::Params::Integer

    # @param flag [Integer]
    # @return [Boolean]
    def has_flag?(flag)
      (flags || 0) & flag == flag
    end
  end
end
