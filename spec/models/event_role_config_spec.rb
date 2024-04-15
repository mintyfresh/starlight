# frozen_string_literal: true

# == Schema Information
#
# Table name: event_role_configs
#
#  id              :bigint           not null, primary key
#  event_id        :bigint           not null
#  discord_role_id :bigint
#  name            :string           not null
#  permissions     :string           default("0"), not null
#  colour          :integer          default(0), not null
#  hoist           :boolean          default(FALSE), not null
#  mentionable     :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_event_role_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe EventRoleConfig do
  subject(:config) { build(:event_role_config) }

  it 'has a valid factory' do
    expect(config).to be_valid
  end

  it 'is invalid without an event' do
    config.event = nil
    expect(config).to be_invalid
  end

  it 'is invalid without a name' do
    config.name = nil
    expect(config).to be_invalid
  end

  it 'is invalid with a name longer than 100 characters' do
    config.name = 'a' * 101
    expect(config).to be_invalid
  end

  it 'is invalid without permissions' do
    config.permissions = nil
    expect(config).to be_invalid
  end

  it 'is invalid with a colour outside the range 0x000000..0xFFFFFF', :aggregate_failures do
    config.colour = -1
    expect(config).to be_invalid
    config.colour = 0x1_000_000
    expect(config).to be_invalid
  end

  it 'is invalid without a hoist flag' do
    config.hoist = nil
    expect(config).to be_invalid
  end

  it 'is invalid without a mentionable flag' do
    config.mentionable = nil
    expect(config).to be_invalid
  end

  it 'accepts colour values as integers', :aggregate_failures do
    config.colour = 123_456
    expect(config.colour).to eq(123_456)
    expect(config.colour_as_hex).to eq('#01E240')
  end

  it 'accepts colour values as hex strings', :aggregate_failures do
    config.colour = '#A1B2C3'
    expect(config.colour).to eq(0xA1B2C3)
    expect(config.colour_as_hex).to eq('#A1B2C3')
  end
end
