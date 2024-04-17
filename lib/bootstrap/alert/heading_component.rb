# frozen_string_literal: true

module Bootstrap
  module Alert
    class HeadingComponent < ViewComponent::Base
      # @param text [String, nil]
      # @param html_options [Hash]
      def initialize(text: nil, **html_options)
        super()

        @text         = text
        @html_options = html_options
      end

      def call
        tag.h4(@text || content, **@html_options, class: ['alert-heading', *@html_options[:class]])
      end
    end
  end
end
