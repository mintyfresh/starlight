# frozen_string_literal: true

class NavbarComponent < ApplicationComponent
  # @param current_user [User, nil]
  # @param html_options [Hash]
  def initialize(current_user:, **html_options)
    super()

    @current_user = current_user
    @html_options = html_options
  end
end
