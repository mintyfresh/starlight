# frozen_string_literal: true

module Modals
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

  # @param request [Discord::Interaction::Request]
  # @return [Discord::Interaction::Response, nil]
  def self.submit(request)
    custom_id = request.data.custom_id
    return if custom_id.nil?

    modal_class, record = decode_custom_id(custom_id)
    return if modal_class.nil?

    modal_class.try(:submit, request, record)
  end
end
