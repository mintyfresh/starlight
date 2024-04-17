# frozen_string_literal: true

module Commands
  class Base
    # @return [String]
    def self.default_command_name
      name.demodulize.chomp('Command').underscore.tr('_', '-')
    end

    # @overload command_name
    #   @return [String]
    # @overload command_name(value)
    #   @param value [String]
    #   @return [void]
    def self.command_name(value = nil)
      @command_name = value unless value.nil?

      @command_name || default_command_name
    end

    # @overload command_type
    #   @return [Integer]
    # @overload command_type(value)
    #   @param value [Symbol, Integer]
    #   @return [void]
    def self.command_type(value = nil)
      unless value.nil?
        resolved_value = Discord::ApplicationCommandType.resolve(value) or
          raise ArgumentError, "invalid command type: #{value}"

        @command_type = resolved_value
      end

      @command_type || Discord::ApplicationCommandType::CHAT_INPUT
    end

    # @overload description
    #   @return [String, nil]
    # @overload description(value)
    #   @param value [String]
    #   @return [void]
    def self.description(value = nil)
      @description = value unless value.nil?

      @description
    end

    # @return [Array<Discord::ApplicationCommandOption>]
    def self.options
      @options ||= []
    end

    # @param name [String, Symbol]
    # @param type [Symbol, Integer]
    # @param description [String, nil]
    # @param attributes [Hash]
    # @return [void]
    def self.option(name, type, description = nil, **attributes)
      resolved_type = Discord::ApplicationCommandOptionType.resolve(type) or
        raise ArgumentError, "invalid option type for #{name}: #{type}"

      options << Discord::ApplicationCommandOption.new(
        description:, **attributes, name: name.to_s, type: resolved_type
      )
    end

    # @overload default_member_permissions
    #   @return [String, nil]
    # @overload default_member_permissions(value)
    #   @param value [String]
    #   @return [void]
    def self.default_member_permissions(value = nil)
      @default_member_permissions = value unless value.nil?

      @default_member_permissions
    end

    # @overload dm_permission
    #   @return [Boolean, nil]
    # @overload dm_permission(value)
    #   @param value [Boolean]
    #   @return [void]
    def self.dm_permission(value = nil)
      @dm_permission = value unless value.nil?

      @dm_permission
    end

    # @overload default_permission
    #   @return [Boolean, nil]
    # @overload default_permission(value)
    #   @param value [Boolean]
    #   @return [void]
    def self.default_permission(value = nil)
      @default_permission = value unless value.nil?

      @default_permission
    end

    # @overload nsfw
    #   @return [Boolean, nil]
    # @overload nsfw(value)
    #   @param value [Boolean]
    #   @return [void]
    def self.nsfw(value = nil)
      @nsfw = value unless value.nil?

      @nsfw
    end

    # @return [Discord::ApplicationCommand]
    def self.application_command
      Discord::ApplicationCommand.new(application_command_attributes)
    end

    # @return [Hash]
    def self.application_command_attributes
      {
        name: command_name, type: command_type, description:,
        default_member_permissions:, dm_permission:, default_permission:,
        nsfw:, options: options.presence
      }
    end

    # @param request [Discord::Interaction::Request]
    def initialize(request)
      @request = request
    end

    # @abstract
    # @return [Discord::Interaction::Response]
    def call
      raise NotImplementedError, "#{self.class.name}#call is not implemented."
    end

  protected

    # @return [Discord::Interaction::Request]
    attr_reader :request

    # @return [Hash{String => Discord::ApplicationCommandInteractionDataOption}]
    def options
      @options ||= request.data.options.index_by(&:name)
    end

    # @param name [String, Symbol]
    # @return [Discord::ApplicationCommandInteractionDataOption, nil]
    def option(name)
      options[name.to_s]
    end

    # Converts the options to a Hash with the option names as keys, and the option values as values.
    #
    # @return [Hash{String => String}]
    def options_as_hash
      options.transform_values(&:value)
    end

    # @param message_class [Class<Messages::Base>]
    # @return [Discord::Interaction::Response]
    def render_message(message_class, ...)
      Discord::Interaction::Response.channel_message(message_class.new(...).render)
    end
  end
end
