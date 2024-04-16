# frozen_string_literal: true

# == Schema Information
#
# Table name: decklists
#
#  id              :bigint           not null, primary key
#  registration_id :bigint           not null
#  deck_name       :string
#  ponyhead_url    :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_decklists_on_registration_id  (registration_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#
class Decklist < ApplicationRecord
  DECK_NAME_MAX_LENGTH = 5000

  PONYHEAD_SCHEMES = %w[http https].freeze
  PONYHEAD_HOST = 'ponyhead.com'
  PONYHEAD_PATH = '/deckbuilder'
  PONYHEAD_CARDS_PARAM = 'v1code'

  belongs_to :registration, inverse_of: :decklist

  validates :deck_name, length: { maximum: DECK_NAME_MAX_LENGTH }
  validates :ponyhead_url, presence: true
  validates :cards, presence: true

  validate if: -> { ponyhead_url_changed? && ponyhead_url.present? } do
    # parse and validate that the URL is a PonyHead URL
    parse_ponyhead_url or errors.add(:ponyhead_url, :invalid)
  rescue URI::InvalidURIError
    errors.add(:ponyhead_url, :invalid)
  end

  # Returns a hash of card codes and counts from the PonyHead URL-encoded decklist.
  #
  # @return [Hash{String => Integer}]
  def cards
    encoded_cards_list.split('-').to_h do |card_with_count|
      card, count = card_with_count.split(/x(\d+)\z/)

      [card, count.to_i]
    end
  end

private

  # Extracts the encoded cards list from the PonyHead URL.
  # e.g. https://ponyhead.com/deckbuilder?v1code=ff1x1-sb1x1-de2x1-sb2x1-ff2x1-de6x1-fm3x1-ff9x1
  #
  # @return [String]
  def encoded_cards_list
    query = parse_ponyhead_url&.query
    return '' if query.blank?

    query = Rack::Utils.parse_query(query)
    return '' if query.blank?

    query.fetch(PONYHEAD_CARDS_PARAM, '')
  rescue URI::InvalidURIError
    ''
  end

  # Parses the PonyHead URL and validates that it is a valid PonyHead URL.
  #
  # @return [URI, nil]
  # @note does not currently support shortened URLs
  def parse_ponyhead_url
    uri = URI.parse(ponyhead_url)

    return unless uri.scheme.in?(PONYHEAD_SCHEMES)
    return unless uri.host == PONYHEAD_HOST
    return unless uri.path == PONYHEAD_PATH

    uri
  end
end
