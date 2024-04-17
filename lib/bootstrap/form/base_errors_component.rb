# frozen_string_literal: true

module Bootstrap
  module Form
    class BaseErrorsComponent < ViewComponent::Base
      # @return [Array<ActiveModel::Error>]
      attr_reader :errors
      # @return [String]
      attr_reader :variant
      # @return [Hash]
      attr_reader :html_options

      # @param errors [Array<ActiveModel::Error>]
      # @param variant [String]
      # @param html_options [Hash]
      def initialize(errors:, variant: 'danger', **html_options)
        super()

        @errors       = errors
        @variant      = variant
        @html_options = html_options
      end

      # @return [Boolean]
      def render?
        @errors.any?
      end
    end
  end
end
