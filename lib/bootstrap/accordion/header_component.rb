# frozen_string_literal: true

module Bootstrap
  module Accordion
    class HeaderComponent < ViewComponent::Base
      # @return [String]
      attr_reader :id
      # @return [String]
      attr_reader :collapse_id
      # @return [Boolean]
      attr_reader :expanded
      # @return [Hash]
      attr_reader :button_options
      # @return [Hash]
      attr_reader :html_options

      # @param id [String]
      # @param collapse_id [String]
      # @param expanded [Boolean]
      # @param button_options [Hash]
      # @param html_options [Hash]
      def initialize(id:, collapse_id:, expanded: false, button_options: {}, **html_options)
        super()

        @id             = id
        @collapse_id    = collapse_id
        @expanded       = expanded
        @button_options = button_options
        @html_options   = html_options
      end

      # @return [Array<String>]
      def css_class
        ['accordion-header', *html_options[:class]]
      end

      # @return [Hash]
      def button_aria
        { **html_options.fetch(:aria, {}), controls: collapse_id, expanded: }
      end

      # @return [Array<String>]
      def button_css_class
        ['accordion-button', *('collapsed' unless expanded), *button_options[:button_class]]
      end

      # @return [Hash]
      def button_data
        { **html_options.fetch(:data, {}), bs_toggle: 'collapse', bs_target: collapse_id && "##{collapse_id}" }
      end
    end
  end
end
