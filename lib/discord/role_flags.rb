# frozen_string_literal: true

module Discord
  module RoleFlags
    extend DiscordEnum

    # Role can be selected by members in an onboarding prompt.
    #
    # @type [Integer]
    IN_PROMPT = 1 << 0
  end
end
