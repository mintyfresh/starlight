# frozen_string_literal: true

module Discord
  module MessageActivityType
    extend DiscordEnum

    # @type [Integer]
    JOIN = 1
    # @type [Integer]
    SPECTATE = 2
    # @type [Integer]
    LISTEN = 3
    # @type [Integer]
    JOIN_REQUEST = 5
  end
end
