# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    # @param attributes [Array<Symbol>]
    # @return [void]
    def slugifies(*attributes)
      before_create if: -> { attributes.any? { |attribute| attribute_changed?(attribute) } } do
        self.slug = attributes.map { |attribute| send(attribute) }.join('-').parameterize
      end
    end
  end

  # @return [String]
  def to_param
    slug
  end
end
