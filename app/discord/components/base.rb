# frozen_string_literal: true

module Components
  class Base
    # @return [Discord::Component]
    def self.render(...)
      new(...).render
    end

    # @abstract
    # @return [Discord::Component]
    def render
      raise NotImplementedError, "#{self.class.name}#render is not implemented."
    end
  end
end
