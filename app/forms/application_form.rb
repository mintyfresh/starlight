# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  # @return [ActiveRecord::Base]
  attr_reader :record

  validates :record, presence: { strict: true }

  # @param record [ActiveRecord::Base]
  # @param attributes [Hash]
  def initialize(record, attributes = {})
    @record = record
    super(attributes)
  end

  # Checks if the given attribute has been assigned a value.
  # (ie. saving will update the attribute in the database)
  #
  # @param name [Symbol]
  # @return [Boolean]
  def attribute_assigned?(name)
    assigned_attribute_names.include?(name.to_s)
  end

  # Returns the attributes Hash with only the attributes that have been assigned a value.
  #
  # @return [Hash{String => Object}]
  def assigned_attributes
    attributes.slice(*assigned_attribute_names)
  end

  # Returns the names of the attributes that have been assigned a value.
  #
  # @return [Array<String>]
  def assigned_attribute_names
    @attributes.each_value.select(&:changed?).map(&:name)
  end

  # @abstract
  # @return [Boolean]
  def save
    raise NotImplementedError, "#{self.class.name}#save is not implemented."
  end

  # @return [true]
  # @raise [ActiveModel::ValidationError] if the form is invalid
  def save!
    save or raise ActiveModel::ValidationError, self
  end

protected

  # @param errors [ActiveModel::Errors]
  # @param prefix [String, nil]
  # @return [void]
  def import_errors_from(errors, prefix: nil)
    errors.each do |error|
      self.errors.import(error, attribute: [prefix, error.attribute].compact.join)
    end
  end
end
