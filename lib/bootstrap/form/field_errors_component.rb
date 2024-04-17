# frozen_string_literal: true

module Bootstrap
  module Form
    class FieldErrorsComponent < ViewComponent::Base
      # @return [Array<ActiveModel::Error>]
      attr_reader :errors
      # @return [Hash]
      attr_reader :html_options

      # @param errors [Array<ActiveModel::Error>]
      # @param html_options [Hash]
      def initialize(errors:, **html_options)
        super()

        @errors       = errors
        @html_options = html_options
      end

      # @return [Boolean]
      def render?
        @errors.any?
      end

      # @return [Array<String>]
      def css_class
        ['invalid-feedback', *@html_options[:class]]
      end
    end
  end
end
