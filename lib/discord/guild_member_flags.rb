# frozen_string_literal: true

module Discord
  module GuildMemberFlags
    extend DiscordEnum

    # Member has left and re-joined the guild.
    #
    # @type [Integer]
    DID_REJOIN = 1 << 0
    # Member has completed onboarding.
    #
    # @type [Integer]
    COMPLETED_ONBOARDING = 1 << 1
    # Member is exempt from guild verification requirements.
    #
    # @type [Integer]
    BYPASSES_VERIFICATION = 1 << 2
    # Member has started onboarding.
    #
    # @type [Integer]
    STARTED_ONBOARDING = 1 << 3
  end
end
