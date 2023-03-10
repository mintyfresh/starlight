# frozen_string_literal: true

module Types
  class ErrorType < BaseObject
    field :attribute, String, null: false
    field :message, String, null: false do
      argument :full, Boolean, required: false, default_value: false
    end

    # @return [String]
    def attribute
      object.attribute.to_s.camelize(:lower)
    end

    # @param full [Boolean]
    # @return [String]
    def message(full:)
      full ? object.full_message : object.message
    end
  end
end
