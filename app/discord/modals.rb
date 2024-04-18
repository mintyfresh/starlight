# frozen_string_literal: true

module Modals
  # @!scope class
  # @!attribute logger
  #   @return [Logger]
  mattr_accessor :logger, default: Rails.logger

  # @param modal [Modals::Base::Template]
  # @param record [ApplicationRecord, nil]
  # @return [String]
  def self.encode_custom_id(modal, record = nil)
    [
      modal.class.name.delete_prefix('Modals::'),
      record&.class&.base_class&.name,
      record&.id
    ].compact.join('/')
  end

  # @param custom_id [String]
  # @return [(Modals::Base, ApplicationRecord), (Modals::Base, nil)]
  def self.decode_custom_id(custom_id)
    modal_class, record_class, record_id = custom_id.split('/', 3)

    modal_class = "Modals::#{modal_class}".constantize
    record = record_class && record_id && record_class.constantize.find(record_id)

    [modal_class, record]
  end

  # Handles a modal submission request.
  # Decodes the custom ID and calls the appropriate submission handler.
  #
  # @param request [Discord::Interaction::Request]
  # @return [Discord::Interaction::Response, nil]
  def self.submit(request)
    if (custom_id = request.data.custom_id).nil?
      logger.warn { "No custom ID in modal submission: #{request.inspect}" }
      return
    end

    if (modal_class, record = decode_custom_id(custom_id)).nil?
      logger.warn { "Failed to decode custom ID: #{custom_id}" }
      return
    end

    if (response = modal_class.try(:submit, request, record)).nil?
      logger.warn { "No submission handler for modal: #{modal_class}" }
      return
    end

    response
  end
end
