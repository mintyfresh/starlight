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

    # @return [Hash{Symbol => Integer}]
    def to_hash
      @to_hash ||= constants(false).index_with { |name| const_get(name) }.freeze
    end
  end
end
