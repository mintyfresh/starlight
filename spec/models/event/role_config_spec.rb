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
#  cleanup_delay   :interval
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

RSpec.describe Event::RoleConfig do
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

  describe '.ready_for_cleanup' do
    subject(:ready_for_cleanup) { described_class.ready_for_cleanup }

    let(:config) { create(:event_role_config, :with_discord_role_id, event:, cleanup_delay: 1.week) }
    let(:event) { create(:event, :past) }

    it 'includes role configurations past their cleanup delay' do
      expect(ready_for_cleanup).to include(config)
    end

    it "doesn't include role configurations without a cleanup delay" do
      config.update!(cleanup_delay: nil)
      expect(ready_for_cleanup).not_to include(config)
    end

    it "doesn't include role configurations without a Discord role ID" do
      config.update!(discord_role_id: nil)
      expect(ready_for_cleanup).not_to include(config)
    end

    it "doesn't include role configurations for events without an end date" do
      config.event.update!(ends_at: nil)
      expect(ready_for_cleanup).not_to include(config)
    end

    it "doesn't include role configurations for events that haven't ended" do
      config.event.update!(ends_at: 1.week.from_now)
      expect(ready_for_cleanup).not_to include(config)
    end
  end
end
