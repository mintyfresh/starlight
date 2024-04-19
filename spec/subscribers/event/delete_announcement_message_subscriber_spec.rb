# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::DeleteAnnouncementMessageSubscriber, type: :subscriber do
  subject(:subscriber) { described_class }

  it 'accepts Event::AnnouncementConfig::DestroyMessage when it has a message ID' do
    event_announcement_config = create(:event_announcement_config, :with_discord_message_id)
    expect(subscriber).to accept(Event::AnnouncementConfig::DestroyMessage.new(event_announcement_config:))
  end

  it 'does not accept Event::AnnouncementConfig::DestroyMessage when it does not have a message ID' do
    event_announcement_config = create(:event_announcement_config)
    expect(subscriber).not_to accept(Event::AnnouncementConfig::DestroyMessage.new(event_announcement_config:))
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:subscriber) { described_class.new(message) }
    let(:message) { Event::AnnouncementConfig::DestroyMessage.new(event_announcement_config:) }
    let(:event_announcement_config) { create(:event_announcement_config, :with_discord_message_id) }

    it 'deletes the announcement message from Discord', :aggregate_failures do
      delete_discord_message = stub_discord_delete_message(
        event_announcement_config.discord_channel_id, event_announcement_config.discord_message_id
      )

      perform
      expect(delete_discord_message).to have_been_requested.once
    end
  end
end
