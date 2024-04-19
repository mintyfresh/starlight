# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::CreateAnnouncementMessageSubscriber, type: :subscriber do
  subject(:subscriber) { described_class }

  it 'accepts Event::PublishMessage when the event has an announcement configuration' do
    event = create(:event, :published, :with_announcement_config)
    expect(subscriber).to accept(Event::PublishMessage.new(event:))
  end

  it 'does not accept Event::PublishMessage when the event does not have an announcement configuration' do
    event = create(:event, :published)
    expect(subscriber).not_to accept(Event::PublishMessage.new(event:))
  end

  it 'does not accept Event::PublishMessage when the event has an announcement configuration with a message ID' do
    event = create(:event, :published, :with_announcement_config)
    event.announcement_config.update!(discord_message_id: Faker::Number.number(digits: 18))
    expect(subscriber).not_to accept(Event::PublishMessage.new(event:))
  end

  it 'accepts Event::AnnouncementConfig::CreateMessage when the event is published' do
    event = create(:event, :published)
    event_announcement_config = create(:event_announcement_config, event:)
    expect(subscriber).to accept(Event::AnnouncementConfig::CreateMessage.new(event_announcement_config:))
  end

  it 'does not accept Event::AnnouncementConfig::CreateMessage when the event is not published' do
    event = create(:event, :draft)
    event_announcement_config = create(:event_announcement_config, event:)
    expect(subscriber).not_to accept(Event::AnnouncementConfig::CreateMessage.new(event_announcement_config:))
  end

  it 'does not accept Event::AnnouncementConfig::CreateMessage when the announcement configuration has a message ID' do
    event = create(:event, :published)
    event_announcement_config = create(:event_announcement_config, :with_discord_message_id, event:)
    expect(subscriber).not_to accept(Event::AnnouncementConfig::CreateMessage.new(event_announcement_config:))
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:subscriber) { described_class.new(message) }
    let(:message) { Event::PublishMessage.new(event:) }
    let(:event) { create(:event, :published, :with_announcement_config) }

    it 'creates a discord message and saves its ID to the announcement configuration', :aggregate_failures do
      discord_message_id = Faker::Number.number(digits: 18)
      create_discord_message = stub_discord_create_message(
        event.announcement_config.discord_channel_id, Messages::EventAnnouncement.render(event)
      ) do |_, response|
        response[:body][:id] = discord_message_id
      end

      perform
      expect(event.announcement_config.reload.discord_message_id).to eq(discord_message_id)
      expect(create_discord_message).to have_been_requested.once
    end
  end
end
