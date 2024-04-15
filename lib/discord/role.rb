# frozen_string_literal: true

module Discord
  class Role < DiscordObject
    # @!attribute [r] type
    #   Role ID
    #   @return [Integer]
    attribute? :id, T::Params::Integer.optional
    # @!attribute [r] name
    #   Role name
    #   @return [String]
    attribute? :name, T::Params::String
    # @!attribute [r] color
    #   Integer representation of hexadecimal color code
    #   @return [Integer]
    attribute? :color, T::Params::Integer
    # @!attribute [r] hoist
    #   If this role is pinned in the user listing
    #   @return [Boolean]
    attribute? :hoist, T::Params::Bool
    # @!attribute [r] position
    #   Position of this role
    #   @return [Integer]
    attribute? :position, T::Params::Integer
    # @!attribute [r] permissions
    #   Permission bit set
    #   @return [String]
    attribute? :permissions, T::Params::String.default('0')
    # @!attribute [r] managed
    #   Whether this role is managed by an integration
    #   @return [Boolean]
    attribute? :managed, T::Params::Bool
    # @!attribute [r] mentionable
    #   Whether this role is mentionable
    #   @return [Boolean]
    attribute? :mentionable, T::Params::Bool
    # @!attribute [r] flags
    #   Role flags combined as a bitfield
    #   @return [Integer]
    attribute? :flags, T::Params::Integer

    alias colour color
  end
end
