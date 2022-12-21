# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    # @param slug_or_id [String]
    # @return [ActiveRecord::Base, nil]
    def find_by_slug_or_id(slug_or_id)
      find_by(id: slug_or_id.to_s.split('-').last || slug_or_id)
    end

    # @param slug_or_id [String]
    # @return [ActiveRecord::Base]
    def find_by_slug_or_id!(slug_or_id)
      find(slug_or_id.to_s.split('-').last || slug_or_id)
    end

    # @param fields [Array<Symbol>]
    # @return [void]
    def sluggify(*fields)
      define_method(:slug) do
        fields.filter_map { |field| send(field) }.join('-').parameterize
      end
    end
  end

  # @abstract
  # @return [String]
  def slug
    raise NotImplementedError, "#{self.class.name}#slug is not implemented"
  end

  # @return [String]
  def to_param
    slug
  end
end
