# frozen_string_literal: true

class PonyheadURLParser
  class ShortLinkDecoder
    class DecodeError < StandardError
    end

    ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'
    BITS_PER_CHAR = 6

    # @type [Array<String>]
    KNOWN_SET_NAMES = %w[
      pr prPF cn cnf cnPF rr rrF cs csf csF
      cg cg0 cgpf cgPF gf ad adn adpf eo hm
      hmn mt de sb ff ll nd fm
    ].freeze

    # @param encoded [String]
    def initialize(encoded)
      @bit_array = decode_to_bit_array(encoded)

      validate_format_version!
      @draft_mode = pop_boolean
    end

    # @return [Array<(String, Integer)>]
    def decode
      known_sets = decode_known_sets
      unknown_sets = decode_unknown_sets

      # sanity check: bit array should be empty (or only contain padding 0 bits)
      unless @bit_array.empty? || (@bit_array.size < BITS_PER_CHAR && @bit_array.all?(&:zero?))
        raise DecodeError, "unexpected bits remaining: #{@bit_array.inspect}"
      end

      (known_sets + unknown_sets).flat_map do |set|
        set[:slots].map do |(card_id, count)|
          ["#{set[:set_id]}#{card_id}", count]
        end
      end
    end

  private

    # @return [Array<Hash{Symbol => Object}>]
    def decode_known_sets
      known_sets = []

      known_sets_count = pop_golomb(3)
      return known_sets if known_sets_count.zero?

      set_index = pop_golomb(4)
      known_sets << { set_id: KNOWN_SET_NAMES[set_index], slots: decode_slots }

      (known_sets_count - 1).times do
        set_index += pop_golomb(2) + 1
        known_sets << { set_id: KNOWN_SET_NAMES[set_index], slots: decode_slots }
      end

      known_sets
    end

    # @return [Array<Hash{Symbol => Object}>]
    def decode_unknown_sets
      set_name_length = 1
      unknown_sets_count = pop_golomb(0)

      unknown_sets = Array.new(unknown_sets_count) do
        set_name_length += pop_golomb(0)
        { set_name_length:, slots: decode_slots }
      end

      unknown_sets.each do |set|
        set[:set_id] = pop_string(set[:set_name_length])
      end

      unknown_sets
    end

    # @return [void]
    def validate_format_version!
      (version = pop_golomb(1).zero?) or
        raise DecodeError, "invalid version: #{version} (expected 0)"
    end

    # @return [Array<(Integer, Integer)>]
    # @see https://github.com/Hithroc/tts-deck-creator/blob/master/static/app.js#L170-L191
    def decode_slots # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      id = -1
      slots_count = pop_golomb(1) + 1

      Array.new(slots_count) do |index|
        count = 0

        if @draft_mode
          id += pop_golomb(index.zero? ? 5 : 4) + 1
          count = pop_golomb(1) + 1
        else
          code = pop_golomb(index.zero? ? 6 : 5)
          id += (code / 3).floor + 1
          count = (code % 3) + 1
        end

        [id, count]
      end
    end

    # @return [Boolean]
    def pop_boolean
      pop_bit == 1
    end

    # @return [Integer]
    def pop_bit
      pop_bits(1)
    end

    # @param count [Integer]
    # @return [Integer]
    # @raise [ArgumentError] if count exceeds the number of bits available
    def pop_bits(count)
      count <= @bit_array.size or
        raise DecodeError, "count (#{count}) exceeds the number of bits available (#{@bit_array.size})"

      @bit_array.shift(count).each_with_index.reduce(0) { |acc, (bit, index)| acc + (bit << index) }
    end

    # @param k [Integer]
    # @return [Integer]
    # @see https://github.com/Hithroc/tts-deck-creator/blob/master/static/app.js#L160-L168
    def pop_golomb(k) # rubocop:disable Naming/MethodParameterName
      n = 0
      n += 1 while pop_bit.zero?

      x = pop_bits(n)
      y = pop_bits(k)

      ((x + (1 << n) - 1) << k) + y
    end

    # @param length [Integer]
    # @return [String]
    def pop_string(length)
      Array.new(length) { ALPHABET[pop_bits(BITS_PER_CHAR)] }.join
    end

    # @param encoded [String]
    # @return [Array<Integer>]
    def decode_to_bit_array(encoded)
      buffer = encoded.each_char.map.with_index do |char, index|
        ALPHABET.index(char) or raise DecodeError, "invalid character at position #{index}"
      end

      # convert the buffer to a bit array (e.g. [1, 0, 1, 0, 1, 1, 0, 0, ...])
      buffer.flat_map { |byte| byte.to_s(2).rjust(BITS_PER_CHAR, '0').each_char.map(&:to_i).reverse! }
    end
  end
end
