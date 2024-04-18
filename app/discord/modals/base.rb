# frozen_string_literal: true

module Modals
  class Base
    include Rails.application.routes.url_helpers

    class SubmitHandler
      include Rails.application.routes.url_helpers

      # @param request [Discord::Interaction::Request]
      # @param record [ApplicationRecord, nil]
      def initialize(request, record)
        @request = request
        @record  = record
      end

      # @abstract
      # @return [Discord::Interaction::Response]
      def submit
        raise NotImplementedError, "#{self.class.name}#submit is not implemented."
      end

    protected

      # @return [Discord::Interaction::Request]
      attr_reader :request
      # @return [ApplicationRecord, nil]
      attr_reader :record

      # @return [Discord::ModalSubmitData]
      def modal_submit_data
        request.data
      end

      # @return [Hash{String => String}]
      def attributes
        modal_submit_data.components.flat_map(&:components).index_by(&:custom_id).transform_values(&:value)
      end

      # @return [Hash]
      def default_url_options
        Rails.application.config.action_controller.default_url_options
      end
    end

    # @return [Discord::Interaction::Response::ModalResponseData]
    def self.render(...)
      new(...).render
    end

    # @param request [Discord::Interaction::Request]
    # @param record [ApplicationRecord, nil]
    # @return [Discord::Interaction::Response]
    def self.submit(...)
      self::SubmitHandler.new(...).submit
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

    # Defines a linked record for the modal submission.
    # This record will be passed to the modal's submit handler.
    # Only a single record can be linked to a modal.
    #
    # @yieldreturn [ApplicationRecord, nil]
    # @return [void]
    def self.record_for_submit(&block)
      define_method(:custom_id) do
        Modals.encode_custom_id(self, instance_exec(&block))
      end
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
      Modals.encode_custom_id(self)
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

    # @return [Hash]
    def default_url_options
      Rails.application.config.action_controller.default_url_options
    end
  end
end
