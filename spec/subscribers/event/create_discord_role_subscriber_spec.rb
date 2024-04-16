# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::CreateDiscordRoleSubscriber, type: :subscriber do
  subject(:subscriber) { described_class }

  it 'accepts Event::RoleConfig::CreateMessage when the event is published' do
    event = create(:event, :published)
    event_role_config = create(:event_role_config, event:)
    expect(subscriber).to accept(Event::RoleConfig::CreateMessage.new(event_role_config:))
  end

  it 'does not accept Event::RoleConfig::CreateMessage when the event is not published' do
    event = create(:event, :draft)
    event_role_config = create(:event_role_config, event:)
    expect(subscriber).not_to accept(Event::RoleConfig::CreateMessage.new(event_role_config:))
  end

  it 'accepts Event::PublishMessage when the event has a role configuration' do
    event = create(:event, :published, :with_role_config)
    expect(subscriber).to accept(Event::PublishMessage.new(event:))
  end

  it 'does not accept Event::PublishMessage when the event does not have a role configuration' do
    event = create(:event, :published)
    expect(subscriber).not_to accept(Event::PublishMessage.new(event:))
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:subscriber) { described_class.new(message) }
    let(:message) { Event::PublishMessage.new(event:) }
    let(:event) { create(:event, :published, :with_role_config) }

    it 'creates a discord role and saves its ID to the event role configuration', :aggregate_failures do
      discord_role_id = Faker::Number.number(digits: 18)
      create_discord_role = stub_discord_create_guild_role(
        event.discord_guild_id, event.role_config.discord_role_attributes
      ) do |_, response|
        response[:body][:id] = discord_role_id
      end

      perform
      expect(event.role_config.reload.discord_role_id).to eq(discord_role_id)
      expect(create_discord_role).to have_been_requested.once
    end
  end
end
