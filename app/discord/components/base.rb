# frozen_string_literal: true

module Components
  class Base
    include Rails.application.routes.url_helpers

    # @return [Discord::Component]
    def self.render(...)
      new(...).render
    end

    # @abstract
    # @return [Discord::Component]
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
