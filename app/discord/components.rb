# frozen_string_literal: true

module Components
  # @param component [Components::Base]
  # @param record [ApplicationRecord, nil]
  # @return [String]
  def self.encode_custom_id(component, record = nil)
    [component.class.name.delete_prefix('Components::'), record&.class&.sti_name, record&.id].compact.join('/')
  end

  # @param custom_id [String]
  # @return [(Components::Base, ApplicationRecord), (Components::Base, nil)]
  def self.decode_custom_id(custom_id)
    component_class, record_class, record_id = custom_id.split('/', 3)

    component_class = "Components::#{component_class}".constantize
    record = record_class && record_id && record_class.constantize.find(record_id)

    [component_class, record]
  end

  # @param request [Discord::Interaction::Request]
  # @return [Discord::Interaction::Response, nil]
  def self.respond_to_interaction(request)
    custom_id = request.data.custom_id
    return if custom_id.nil?

    component_class, record = decode_custom_id(custom_id)
    return if component_class.nil?

    component_class.try(:respond_to_interaction, request, record)
  end
end
