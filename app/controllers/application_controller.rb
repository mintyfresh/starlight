# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActionPolicy::Unauthorized do |error|
    if current_user
      flash.alert = error.result.reasons.full_messages.to_sentence
      redirect_back fallback_location: root_path
    else
      flash[:return_path] = request.fullpath
      redirect_to auth_sign_in_path
    end
  end

  # @return [User, nil]
  def current_user
    @current_user ||= (user_id = session[:user_id]) && User.find_by(id: user_id)
  end

  # @param user [User, nil]
  # @return [void]
  def current_user=(user)
    case user
    when User
      session[:user_id] = user.id
      @current_user = user
    when nil
      session.delete(:user_id)
      @current_user = nil
    else
      raise ArgumentError, "Invalid user: #{user.inspect} (expected User or nil)"
    end
  end

  # expose current_user to views
  helper_method :current_user
end
