# frozen_string_literal: true

class BeforeAttributeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    before_attribute = options[:with] || options[:attribute]
    before_value = record.send(before_attribute)
    return if before_value.blank?

    value < before_value or record.errors.add(
      attribute, :before_attribute,
      attribute: record.human_attribute_name(before_attribute),
      value:     I18n.l(before_value, format: :datetime_local)
    )
  end
end
