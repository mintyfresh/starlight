# frozen_string_literal: true

module Bootstrap
  module Alert
    class Component < ViewComponent::Base
      VARIANTS = %w[primary secondary success danger warning info light dark].freeze

      renders_one :heading, HeadingComponent

      # @param text [String]
      # @param dismissible [Boolean]
      # @param variant [String]
      # @param html_options [Hash]
      def initialize(text: nil, dismissible: false, variant: 'primary', **html_options)
        super()

        @text         = text
        @dismissible  = dismissible
        @variant      = variant.presence_in(VARIANTS) or raise ArgumentError, "Invalid variant: #{variant.inspect}"
        @html_options = html_options
      end

    private

      # @return [Array<String>]
      def css_class
        ['alert', variant_css_class, *dismissible_css_class, *@html_options[:class]]
      end

      # @return [String]
      def variant_css_class
        "alert-#{@variant}"
      end

      # @return [Array<String>, nil]
      def dismissible_css_class
        %w[alert-dismissible fade show] if @dismissible
      end
    end
  end
end
