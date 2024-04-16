# frozen_string_literal: true

class PonyheadURLParser
  class ParseError < StandardError
  end

  PONYHEAD_SCHEMES = %w[http https].freeze
  PONYHEAD_HOST = 'ponyhead.com'
  PONYHEAD_DECKBUILDER_PATH = '/deckbuilder'
  PONYHEAD_SHORT_URL_PATH = '/d/'
  PONYHEAD_CARDS_PARAM = 'v1code'

  I18N_SCOPE = 'ponyhead.errors'

  # @param url [String]
  # @return [Hash{String => Integer}]
  def self.parse(url)
    new(url).parse
  end

  # @return [String]
  attr_reader :ponyhead_url

  # @param ponyhead_url [String]
  def initialize(ponyhead_url)
    @ponyhead_url = URI.parse(ponyhead_url)

    validate!
  rescue URI::InvalidURIError
    raise_parse_error!(:invalid)
  end

  # @return [Hash{String => Integer}]
  def parse
    if @ponyhead_url.path == PONYHEAD_DECKBUILDER_PATH
      extract_cards_from_query
    elsif @ponyhead_url.path.starts_with?(PONYHEAD_SHORT_URL_PATH)
      extract_cards_from_short_url
    else
      raise NotImplementedError, "unsupported path: #{@ponyhead_url.path}"
    end
  end

private

  # @return [void]
  # @raise [ParseError]
  def validate!
    validate_scheme!
    validate_host!
    validate_path!
    validate_query!
  end

  # @param type [Symbol]
  # @return [void]
  # @raise [ParseError]
  def raise_parse_error!(type)
    raise ParseError, I18n.t(type, scope: I18N_SCOPE)
  end

  # @return [Boolean]
  def validate_scheme!
    PONYHEAD_SCHEMES.include?(@ponyhead_url.scheme) or
      raise_parse_error!(:invalid_scheme)
  end

  # @return [Boolean]
  def validate_host!
    @ponyhead_url.host == PONYHEAD_HOST or
      raise_parse_error!(:invalid_host)
  end

  # @return [Boolean]
  def validate_path!
    (@ponyhead_url.path == PONYHEAD_DECKBUILDER_PATH || @ponyhead_url.path.starts_with?(PONYHEAD_SHORT_URL_PATH)) or
      raise_parse_error!(:invalid_path)
  end

  # @return [Boolean]
  def validate_query!
    # short URLs should not have a query
    return true if @ponyhead_url.path != PONYHEAD_DECKBUILDER_PATH

    (@ponyhead_url.query.present? && Rack::Utils.parse_query(@ponyhead_url.query)[PONYHEAD_CARDS_PARAM].present?) or
      raise_parse_error!(:invalid_query)
  end

  # @return [Hash{String => Integer}]
  def extract_cards_from_query
    query = Rack::Utils.parse_query(@ponyhead_url.query)
    query = query.fetch(PONYHEAD_CARDS_PARAM, '')

    query.split('-').to_h do |card_with_count|
      card, count = card_with_count.split(/x(\d+)\z/)

      [card, count.to_i]
    end
  end

  # @return [Hash{String => Integer}]
  def extract_cards_from_short_url
    cards_list = @ponyhead_url.path.remove(PONYHEAD_SHORT_URL_PATH)
    cards_list = ShortLinkDecoder.new(cards_list).decode

    cards_list.to_h
  rescue ShortLinkDecoder::DecodeError
    raise_parse_error!(:invalid_short_url)
  end
end
