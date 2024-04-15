# frozen_string_literal: true

module Discord
  module Components
    module ButtonStyle
      extend DiscordEnum

      # Blurple button
      # Requires field `custom_id`
      #
      # @type [Integer]
      PRIMARY = 1
      # Grey button
      # Requires field `custom_id`
      #
      # @type [Integer]
      SECONDARY = 2
      # Green button
      # Requires field `custom_id`
      #
      # @type [Integer]
      SUCCESS = 3
      # Red button
      # Requires field `custom_id`
      #
      # @type [Integer]
      DANGER = 4
      # Grey, navigates to a URL
      # Requires field `url`
      #
      # @type [Integer]
      LINK = 5
    end
  end
end
