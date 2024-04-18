# frozen_string_literal: true

module Components
  class Base
    include Rails.application.routes.url_helpers

    class InteractionHandler
      include Rails.application.routes.url_helpers

      # @param request [Discord::Interaction::Request]
      # @param record [ApplicationRecord, nil]
      def initialize(request, record)
        @request = request
        @record  = record
      end

      # @abstract
      # @return [Discord::Interaction::Response]
      def interact
        raise NotImplementedError, "#{self.class.name}#interact is not implemented."
      end

    protected

      # @return [Discord::Interaction::Request]
      attr_reader :request
      # @return [ApplicationRecord, nil]
      attr_reader :record

      # @return [Discord::MessageComponentData]
      def message_component_data
        request.data
      end

      # @return [Hash]
      def default_url_options
        Rails.application.config.action_controller.default_url_options
      end
    end

    # @return [Discord::Component]
    def self.render(...)
      new(...).render
    end

    # @param request [Discord::Interaction::Request]
    # @param record [ApplicationRecord, nil]
    # @return [Discord::Interaction::Response]
    def self.interact(...)
      self::InteractionHandler.new(...).interact
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
