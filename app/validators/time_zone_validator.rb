# frozen_string_literal: true

class TimeZoneValidator < ActiveModel::EachValidator
  # @param record [ActiveModel::Model]
  # @param attribute [Symbol]
  # @param value [Object, nil]
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank?

    ActiveSupport::TimeZone[value] or
      record.errors.add(attribute, message)
  end

private

  # @return [Symbol, String]
  def message
    options.fetch(:message, :invalid)
  end
end
