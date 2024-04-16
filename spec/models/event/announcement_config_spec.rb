# frozen_string_literal: true

# == Schema Information
#
# Table name: event_announcement_configs
#
#  id                 :bigint           not null, primary key
#  event_id           :bigint           not null
#  discord_channel_id :bigint           not null
#  discord_message_id :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_event_announcement_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe Event::AnnouncementConfig do
  subject(:config) { build(:event_announcement_config) }

  it 'has a valid factory' do
    expect(config).to be_valid
  end

  it 'is invalid without an event' do
    config.event = nil
    expect(config).to be_invalid
  end

  it 'is invalid without a Discord channel ID' do
    config.discord_channel_id = nil
    expect(config).to be_invalid
  end
end
