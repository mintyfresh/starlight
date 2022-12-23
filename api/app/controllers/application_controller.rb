# frozen_string_literal: true

class ApplicationController < ActionController::API
  AUTHENTICATION_SCHEME = 'Starlight'

  # Keep updated information for the user about where their account is being accessed from
  before_action if: :current_session do
    current_session.update(current_ip: request.ip) if current_session.current_ip != request.ip
  end

  # @return [UserSession, nil] the current user session, if authenticated
  def current_session
    return @current_session if defined?(@current_session)

    @current_session = (token = session_token) && UserSession.find_by_token(token)
  end

  # @return [User, nil] the current user, if authenticated
  def current_user
    current_session&.user
  end

private

  # Extracts the session token from the request Authorization header.
  # This expects the custom authentication scheme of 'Starlight'
  #
  # @return [String, nil] the session token, if present and using the correct scheme
  def session_token
    authorization = request.env['HTTP_AUTHORIZATION']
    return if authorization.blank?

    # Don't attempt to read tokens longer than 300 characters
    type, token = authorization.first(300).split(' ', 2)
    return if type != AUTHENTICATION_SCHEME || token.blank?

    token
  end
end
