# frozen_string_literal: true

module Components
  class Button < Base
    # Defines the label text for the button.
    #
    # @overload label(text)
    #   @param text [String] the label text
    #   @return [void]
    # @overload label(&block)
    #   @yieldreturn [String] the label text
    #   @return [void]
    def self.label(text = nil, &block)
      define_method(:label) { text || instance_exec(&block) }
    end

    # @overload style(style)
    #   @param style [Symbol, Integer] the button style
    #   @return [void]
    # @overload style(&block)
    #   @yieldreturn [Symbol, Integer] the button style
    #   @return [void]
    def self.style(style = nil, &block)
      define_method(:style) do
        Discord::Components::ButtonStyle.resolve(style || instance_exec(&block))
      end
    end

    # Defines the URL to open when the button is clicked.
    # Only applicable for buttons with the `LINK` style.
    #
    # @overload url(url)
    #   @param url [String] the URL to open when the button is clicked
    #   @return [void]
    # @overload url(&block)
    #   @yieldreturn [String] the URL to open when the button is clicked
    #   @return [void]
    def self.url(url = nil, &block)
      define_method(:url) { url || instance_exec(&block) }
    end

    # Defines whether the button is disabled.
    #
    # @overload disabled(disabled)
    #   @param disabled [Boolean] whether the button is disabled
    #   @return [void]
    # @overload disabled(&block)
    #   @yieldreturn [Boolean] whether the button is disabled
    #   @return [void]
    def self.disabled(disabled = nil, &block)
      define_method(:disabled?) do
        disabled.nil? ? instance_exec(&block) : disabled
      end
    end

    # Defines a linked record for the component interaction.
    # This record will be passed to the component's interaction handler.
    # Only a single record can be linked to a component.
    #
    # Not applicable for buttons with the `LINK` style.
    #
    # @yieldreturn [ApplicationRecord, nil]
    # @return [void]
    def self.record_for_interaction(&block)
      define_method(:custom_id) do
        Components.encode_custom_id(self, instance_exec(&block))
      end
    end

    # @return [Discord::Components::Button]
    # @override Components::Base#render
    def render
      Discord::Components::Button.new(**button_attributes, type: Discord::ComponentType::BUTTON)
    end

  protected

    # @return [Hash]
    def button_attributes
      attributes = { style:, label: }
      attributes[:disabled] = true if disabled?

      # `url` and `custom_id` fields are mutually exclusive
      if style == Discord::Components::ButtonStyle::LINK
        attributes[:url] = url
      else
        attributes[:custom_id] = custom_id
      end

      attributes.compact
    end

    # @return [Integer]
    def style
      Discord::Components::ButtonStyle::PRIMARY
    end

    # @abstract
    # @return [String]
    def label
      raise NotImplementedError, "#{self.class.name}#label is not implemented."
    end

    # @return [String, nil]
    def custom_id
      Components.encode_custom_id(self)
    end

    # @return [String, nil]
    def url
      raise NotImplementedError, "#{self.class.name}#url is not implemented."
    end

    # @return [Boolean]
    def disabled?
      false
    end
  end
end
