# frozen_string_literal: true

module Messages
  class Base
    include Rails.application.routes.url_helpers

    # @abstract
    # @return [Discord::Interaction::Response::MessageResponseData]
    def render
      raise NotImplementedError, "#{self.class.name}#render is not implemented."
    end

  protected

    # @return [Hash]
    def default_url_options
      Rails.application.config.action_controller.default_url_options
    end
  end
end
