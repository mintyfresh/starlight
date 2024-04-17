# frozen_string_literal: true

module Components
  class Button < Base
    # @yieldparam request [Discord::Interaction::Request]
    # @yieldparam record [ApplicationRecord, nil]
    # @return [void]
    def self.on_click(&)
      define_singleton_method(:respond_to_interaction, &)
    end

    # @return [Discord::Components::Button]
    def render
      Discord::Components::Button.new(**button_attributes, type: Discord::ComponentType::BUTTON)
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
      Components.encode_custom_id(self)
    end

    # @return [String, nil]
    def url
      return if style != Discord::Components::ButtonStyle::LINK

      # Link buttons must have a URL
      raise NotImplementedError, "#{self.class.name}#url is not implemented."
    end

    # @return [Boolean]
    def disabled?
      false
    end
  end
end
