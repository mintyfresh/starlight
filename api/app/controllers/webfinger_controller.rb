# frozen_string_literal: true

class WebfingerController < ApplicationController
  def show
    user = User.find_by(display_name: params[:resource])
    head :not_found and return if user.nil?

    render json: Webfinger::UserBlueprint.render_as_hash(user), content_type: 'application/jrd+json'
  end
end
