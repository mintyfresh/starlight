# frozen_string_literal: true

module Components
  class Modal < Base
    # @yieldparam request [Discord::Interaction::Request]
    # @yieldparam record [ApplicationRecord, nil]
    # @yieldparam attributes [Hash{String => String}]
    # @yieldreturn [Discord::Interaction::Response]
    # @return [void]
    def self.on_submit
      define_singleton_method(:respond_to_interaction) do |request, record|
        attributes = request.data.components.flat_map(&:components).index_by(&:custom_id).transform_values(&:value)

        yield(request, record, attributes)
      end
    end

    # @overload title(title)
    #   @param title [String]
    #   @return [void]
    # @overload title(&block)
    #   @yieldreturn [String]
    #   @return [void]
    def self.title(title = nil, &block)
      define_method(:title) { title || instance_exec(&block) }
    end

    # @return [Array<Hash>]
    def self.components
      @components ||= []
    end

    # @param custom_id [Symbol, String]
    # @param label [String]
    # @param style [Symbol, Integer]
    # @param options [Hash]
    # @yieldreturn [Hash]
    def self.text_input(custom_id, label = custom_id.to_s.humanize, style: :short, **, &block)
      custom_id = custom_id.to_s
      style = Discord::Components::TextInputStyle.resolve(style)

      components << { **, label:, custom_id:, style:, callback: block }
    end

    # @return [Discord::Interaction::Response::ModalResponseData]
    def render
      Discord::Interaction::Response.modal(modal_attributes)
    end

  protected

    # @return [Hash]
    def modal_attributes
      { title:, custom_id:, components: }
    end

    # @abstract
    # @return [String]
    def title
      raise NotImplementedError, "#{self.class.name}#title is not implemented."
    end

    # @return [String]
    def custom_id
      Components.encode_custom_id(self)
    end

    # @return [Array]
    def components
      self.class.components.map do |component|
        if (callback = component[:callback])
          component = component.except(:callback).merge(instance_exec(&callback))
        end

        text_input = Discord::Components::TextInput.new(**component)

        Discord::Components::ActionRow.new(components: [text_input])
      end
    end
  end
end
