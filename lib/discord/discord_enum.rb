# frozen_string_literal: true

module Discord
  module DiscordEnum
    # @return [Array<Integer>]
    def all
      @all ||= constants(false).map { |name| const_get(name) }.freeze
    end

    # @param name [Symbol, String]
    # @return [Integer, nil]
    def find(name)
      const_get(name) if const_defined?(name)
    end

    # @param value [Symbol, String, Integer]
    # @return [Integer, nil]
    # @raise [TypeError] if the value is not a Symbol, String, or Integer
    def resolve(value)
      case value
      when Symbol, String
        find(value.to_s.upcase)
      when Integer
        value.presence_in(all)
      else
        raise TypeError, "expected Symbol, String, or Integer, got #{value.class}"
      end
    end

    # @return [Hash{Symbol => Integer}]
    def to_hash
      @to_hash ||= constants(false).index_with { |name| const_get(name) }.freeze
    end
  end
end
