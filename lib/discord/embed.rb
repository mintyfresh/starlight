# frozen_string_literal: true

module Discord
  class Embed < DiscordObject
    TYPE = 'rich'

    attribute? :title, T::Params::String
    attribute? :type, T::Params::String.default(TYPE)
    attribute? :description, T::Params::String
    attribute? :url, T::Params::String
    attribute? :timestamp, T::Params::DateTime
    attribute? :color, T::Params::Integer
    attribute? :footer do
      attribute? :text, T::Params::String
      attribute? :icon_url, T::Params::String
      attribute? :proxy_icon_url, T::Params::String
    end
    attribute? :image do
      attribute? :url, T::Params::String
      attribute? :proxy_url, T::Params::String
      attribute? :height, T::Params::Integer
      attribute? :width, T::Params::Integer
    end
    attribute? :thumbnail do
      attribute? :url, T::Params::String
      attribute? :proxy_url, T::Params::String
      attribute? :height, T::Params::Integer
      attribute? :width, T::Params::Integer
    end
    attribute? :video do
      attribute? :url, T::Params::String
      attribute? :proxy_url, T::Params::String
      attribute? :height, T::Params::Integer
      attribute? :width, T::Params::Integer
    end
    attribute? :provider do
      attribute? :name, T::Params::String
      attribute? :url, T::Params::String
    end
    attribute? :author do
      attribute? :name, T::Params::String
      attribute? :url, T::Params::String
      attribute? :icon_url, T::Params::String
      attribute? :proxy_icon_url, T::Params::String
    end
    attribute? :fields, T::Params::Array do
      attribute :name, T::Params::String
      attribute :value, T::Params::String
      attribute? :inline, T::Params::Bool
    end
  end
end
