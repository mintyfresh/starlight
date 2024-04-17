# frozen_string_literal: true

# == Schema Information
#
# Table name: event_decklist_configs
#
#  id                :bigint           not null, primary key
#  event_id          :bigint           not null
#  decklist_required :boolean          default(FALSE), not null
#  format            :string
#  format_behaviour  :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_event_decklist_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe Event::DecklistConfig do
  subject(:config) { build(:event_decklist_config) }

  it 'has a valid factory' do
    expect(config).to be_valid
  end

  it 'is invalid without an event' do
    config.event = nil
    expect(config).to be_invalid
  end

  it 'is invalid without a decklist requirement' do
    config.decklist_required = nil
    expect(config).to be_invalid
  end

  it 'is valid without a format' do
    config.format = nil
    expect(config).to be_valid
  end

  it 'is invalid with an unknown format' do
    config.format = 'unknown'
    expect(config).to be_invalid
  end

  it 'is valid without a format and a format behaviour' do
    config.format = nil
    config.format_behaviour = nil
    expect(config).to be_valid
  end

  it 'is invalid without a format behaviour if a format is present' do
    config.format = 'core'
    config.format_behaviour = nil
    expect(config).to be_invalid
  end

  it 'is valid with a format behaviour if a format is present' do
    config.format = 'core'
    config.format_behaviour = 'reject_invalid'
    expect(config).to be_valid
  end

  it 'is invalid with an unknown format behaviour' do
    config.format_behaviour = 'unknown'
    expect(config).to be_invalid
  end
end
