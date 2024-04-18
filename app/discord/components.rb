# frozen_string_literal: true

module Components
  # @!scope class
  # @!attribute logger
  #   @return [Logger]
  mattr_accessor :logger, default: Rails.logger

  # @param component [Components::Base]
  # @param record [ApplicationRecord, nil]
  # @return [String]
  def self.encode_custom_id(component, record = nil)
    [
      component.class.name.delete_prefix('Components::'),
      record&.class&.base_class&.name,
      record&.id
    ].compact.join('/')
  end

  # @param custom_id [String]
  # @return [(Components::Base, ApplicationRecord), (Components::Base, nil)]
  def self.decode_custom_id(custom_id)
    component_class, record_class, record_id = custom_id.split('/', 3)

    component_class = "Components::#{component_class}".constantize
    record = record_class && record_id && record_class.constantize.find(record_id)

    [component_class, record]
  end

  # Handles a component interaction request.
  # Decodes the custom ID and calls the appropriate interaction handler.
  #
  # @param request [Discord::Interaction::Request]
  # @return [Discord::Interaction::Response, nil]
  def self.interact(request)
    if (custom_id = request.data.custom_id).nil?
      logger.warn { "No custom ID in interaction request: #{request.inspect}" }
      return
    end

    if (component_class, record = decode_custom_id(custom_id)).nil?
      logger.warn { "Failed to decode custom ID: #{custom_id}" }
      return
    end

    if (response = component_class.try(:interact, request, record)).nil?
      logger.warn { "No interaction handler for component: #{component_class}" }
      return
    end

    response
  end
end
