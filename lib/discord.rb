# frozen_string_literal: true

module Discord
  # @return [OAuth2::Client]
  def self.oauth_client
    OAuth2::Client.new(
      ENV.fetch('DISCORD_CLIENT_ID'),
      ENV.fetch('DISCORD_CLIENT_SECRET'),
      site:          'https://discord.com',
      authorize_url: '/api/oauth2/authorize',
      token_url:     '/api/oauth2/token'
    )
  end
end
