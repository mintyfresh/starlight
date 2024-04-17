# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :save_return_path, only: :sign_in
  before_action :validate_oauth2_state, only: :discord

  # GET /auth/sign_in
  def sign_in
    # generate a random state to prevent forgery
    state = SecureRandom.base58(32)
    cookies.encrypted[:discord_state] = {
      value:    state,
      httponly: true,
      secure:   true
    }

    authorize_url = Discord.oauth_authorize_url(auth_discord_url, state:)
    redirect_to authorize_url, allow_other_host: true
  end

  # GET /auth/discord
  def discord
    access_token = Discord.oauth_client.auth_code.get_token(
      params[:code], redirect_uri: auth_discord_url
    )

    client = Discord::Client.user(access_token.token)
    self.current_user = User.upsert_from_discord!(client.me)

    redirect_to return_path, notice: t('.success', name: current_user.username)
  end

private

  # @return [String]
  def return_path
    session.delete(:return_path) || root_path
  end

  # @return [void]
  def save_return_path
    if (return_path = params[:return_to]).present?
      session[:return_path] = return_path
    elsif !request.referer.match?(%r{/auth/(?:[^/]*)$})
      session[:return_path] = request.referer
    else
      session.delete(:return_path)
    end
  end

  # @return [void]
  def validate_oauth2_state
    expected_value = cookies.encrypted[:discord_state]
    actual_value   = params[:state]

    ActiveSupport::SecurityUtils.secure_compare(expected_value, actual_value) or
      redirect_to root_path, alert: t('.invalid_state') and return

    # clear the state cookie after successful validation
    cookies.encrypted.delete(:discord_state)
  end
end
