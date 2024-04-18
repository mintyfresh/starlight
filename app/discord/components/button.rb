# frozen_string_literal: true

module Components
  class Button < Base
    # @yieldparam request [Discord::Interaction::Request]
    # @yieldparam record [ApplicationRecord, nil]
    # @yieldreturn [Discord::Interaction::Response]
    # @return [void]
    def self.on_click(&)
      define_singleton_method(:respond_to_interaction, &)
    end

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

    # @overload url(url)
    #   @param url [String] the URL to open when the button is clicked
    #   @return [void]
    # @overload url(&block)
    #   @yieldreturn [String] the URL to open when the button is clicked
    #   @return [void]
    def self.url(url = nil, &block)
      define_method(:url) { url || instance_exec(&block) }
    end

    # @return [Discord::Components::Button]
    def render
      Discord::Components::Button.new(**button_attributes, type: Discord::ComponentType::BUTTON)
    end

    # @return [Boolean]
    def link?
      style == Discord::Components::ButtonStyle::LINK
    end

  protected

    # @return [Hash]
    def button_attributes
      { style:, label:, custom_id:, url:, disabled: disabled? }.compact
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
      Components.encode_custom_id(self) unless link?
    end

    # @return [String, nil]
    def url
      raise NotImplementedError, "#{self.class.name}#url is not implemented." if link?
    end

    # @return [Boolean]
    def disabled?
      false
    end
  end
end
