# frozen_string_literal: true

module Components
  class Embed < Base
    MAX_FIELDS_COUNT = 25

    # @overload title(value)
    #   @param value [String]
    #   @return [void]
    # @overload title
    #   @yieldreturn [String]
    #   @return [void]
    def self.title(title = nil, &block)
      define_method(:title) { (title || instance_exec(&block)).presence }
    end

    # @overload description(value)
    #   @param value [String]
    #   @return [void]
    # @overload description
    #   @yieldreturn [String]
    #   @return [void]
    def self.description(description = nil, &block)
      define_method(:description) { (description || instance_exec(&block)).presence }
    end

    # @return [Hash{String => Proc}]
    def self.fields
      @fields ||= {}
    end

    # @param name [String]
    # @yieldreturn [String, Hash, nil]
    # @return [void]
    def self.field(name, &block)
      # prevent adding more fields than the maximum allowed
      if fields.size >= MAX_FIELDS_COUNT && !fields.key?(name)
        raise ArgumentError, "fields count exceeds the maximum of #{MAX_FIELDS_COUNT}"
      end

      fields[name] = block
    end

    # @overload footer(value)
    #   @param value [String, Hash]
    #   @return [void]
    # @overload footer
    #   @yieldreturn [String, Hash, nil]
    #   @return [void]
    def self.footer(footer = nil, &)
      define_method(:footer) do
        value = (footer || instance_exec(&)).presence
        value = { text: value } if value.is_a?(String)

        value
      end
    end

    # @private
    def self.inherited(subclass)
      super
      subclass.fields.merge!(fields)
    end

    # @return [Discord::Embed]
    def render
      Discord::Embed.new(**embed_attributes)
    end

  protected

    # @return [Hash]
    def embed_attributes
      { title:, description:, fields:, footer: }.compact
    end

    # @abstract
    # @return [String]
    def title
      raise NotImplementedError, "#{self.class.name}#title is not implemented."
    end

    # @return [String, nil]
    def description
      nil
    end

    # @return [Array, nil]
    def fields
      self.class.fields.transform_values { |block| instance_exec(&block) }.compact_blank.map do |name, value|
        value = { value: } if value.is_a?(String)

        { **value, name: }
      end.presence
    end

    # @return [Discord::EmbedFooter, nil]
    def footer
      nil
    end
  end
end
