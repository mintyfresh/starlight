# frozen_string_literal: true

class ApplicationController < ActionController::Base
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
