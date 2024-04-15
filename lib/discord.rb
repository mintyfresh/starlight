# frozen_string_literal: true

module Discord
  DEFAULT_SCOPE = %w[identify].freeze

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

  # @param redirect_uri [String]
  # @param scope [Array<String>]
  # @return [String]
  def self.oauth_authorize_url(redirect_uri, scope: DEFAULT_SCOPE, **)
    oauth_client.auth_code.authorize_url(**, redirect_uri:, scope: scope.join(' '))
  end
end
