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

  validate if: -> { ponyhead_url_changed? && ponyhead_url.present? } do
    cards = PonyheadURLParser.parse(ponyhead_url)
    cards.present? or errors.add(:ponyhead_url, :does_not_contain_cards)
  rescue PonyheadURLParser::ParseError
    errors.add(:ponyhead_url, :invalid)
  end

  # Returns a hash of card codes and counts from the PonyHead URL-encoded decklist.
  #
  # @return [Hash{String => Integer}]
  def cards
    PonyheadURLParser.parse(ponyhead_url)
  rescue PonyheadURLParser::ParseError => error
    logger.error { "Failed to parse decklist: #{error.message}" }
    logger.debug { error.backtrace.join("\n") }

    {}
  end
end
