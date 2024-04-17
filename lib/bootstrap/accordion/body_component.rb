# frozen_string_literal: true

module Bootstrap
  module Accordion
    class BodyComponent < ViewComponent::Base
      # @return [String]
      attr_reader :id
      # @return [String]
      attr_reader :header_id
      # @return [String, nil]
      attr_reader :parent_id
      # @return [Boolean]
      attr_reader :expanded
      # @return [Hash]
      attr_reader :html_options

      # @param id [String]
      # @param header_id [String]
      # @param expanded [Boolean]
      # @param html_options [Hash]
      def initialize(id:, header_id:, parent_id: nil, expanded: false, **html_options)
        super()

        @id           = id
        @header_id    = header_id
        @parent_id    = parent_id
        @expanded     = expanded
        @html_options = html_options
      end

      # @return [Hash]
      def aria
        { **html_options.fetch(:aria, {}), labelledby: header_id }
      end

      # @return [Array<String>]
      def css_class
        ['accordion-collapse', 'collapse', *('show' if expanded), *html_options[:class]]
      end

      # @return [Hash]
      def data
        { **html_options.fetch(:data, {}), bs_parent: parent_id && "##{parent_id}" }
      end
    end
  end
end
