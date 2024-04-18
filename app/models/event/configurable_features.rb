# frozen_string_literal: true

class Event
  module ConfigurableFeatures
    extend ActiveSupport::Concern

    class_methods do
      # @param name [Symbol] the name of the configurable feature
      # @param as [Symbol] the name of the generated association
      # @param class_name [String] the name of the class to use for the association
      # @param reject_if [Symbol, Proc] the method or proc to use for rejecting nested attributes
      # @return [void]
      def has_configurable_feature( # rubocop:disable Naming/PredicateName
        name, as: :"#{name}_config", class_name: "Event::#{name.to_s.camelize}Config", reject_if: :all_blank
      )
        has_one(as, class_name:, dependent: :destroy, inverse_of: :event)
        accepts_nested_attributes_for(as, allow_destroy: true, update_only: true, reject_if:)
        validates(as, associated: true)
      end
    end
  end
end
