# frozen_string_literal: true

module Bootstrap
  module Accordion
    class Component < ViewComponent::Base
      # @return [String]
      attr_reader :id
      # @return [Boolean]
      attr_reader :always_open
      # @return [Boolean]
      attr_reader :flush
      # @return [Hash]
      attr_reader :html_options

      renders_many :items, lambda { |**options, &block|
        ItemComponent.new(**options, parent_id: (id unless always_open), &block)
      }

      # @param id [String, nil]
      # @param always_open [Boolean]
      # @param flush [Boolean]
      # @param html_options [Hash]
      def initialize(id: nil, always_open: false, flush: false, **html_options)
        super()

        @id           = id || "bs_accordion_#{SecureRandom.uuid}"
        @always_open  = always_open
        @flush        = flush
        @html_options = html_options
      end

      # @return [Array<String>]
      def css_class
        ['accordion', *('accordion-flush' if flush), *html_options[:class]]
      end
    end
  end
end
