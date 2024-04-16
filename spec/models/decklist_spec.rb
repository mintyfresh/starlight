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
require 'rails_helper'

RSpec.describe Decklist do
  subject(:decklist) { build(:decklist) }

  it 'has a valid factory' do
    expect(decklist).to be_valid
  end

  it 'is invalid without a registration' do
    decklist.registration = nil
    expect(decklist).to be_invalid
  end

  it 'is valid without a deck name' do
    decklist.deck_name = nil
    expect(decklist).to be_valid
  end

  it 'is invalid without a PonyHead URL' do
    decklist.ponyhead_url = nil
    expect(decklist).to be_invalid
  end

  it 'is invalid when the PonyHead URL is not an HTTP(S) URL' do
    decklist.ponyhead_url = 'ftp://ponyhead.com/decklist?v1code=ff1x1'
    expect(decklist).to be_invalid
  end

  it 'is invalid when the PonyHead URL is not a PonyHead URL' do
    decklist.ponyhead_url = 'https://example.com/decklist?v1code=ff1x1'
    expect(decklist).to be_invalid
  end

  it 'is invalid when the PonyHead URL is not a PonyHead decklist URL' do
    decklist.ponyhead_url = 'https://ponyhead.com'
    expect(decklist).to be_invalid
  end

  it 'is invalid when the PonyHead URL has no card data' do
    decklist.ponyhead_url = 'https://ponyhead.com/decklist?v1code='
    expect(decklist).to be_invalid
  end
end
