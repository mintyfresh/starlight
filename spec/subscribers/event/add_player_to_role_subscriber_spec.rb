# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::AddPlayerToRoleSubscriber, type: :subscriber do
  subject(:subscriber) { described_class }

  it 'accepts Registration::CreateMessage when the event has a Discord role' do
    event = create(:event, :published)
    create(:event_role_config, :with_discord_role_id, event:)
    registration = create(:registration, event:)
    expect(subscriber).to accept(Registration::CreateMessage.new(registration:))
  end

  it 'does not accept Registration::CreateMessage when the event does not have a Discord role' do
    event = create(:event, :published)
    registration = create(:registration, event:)
    expect(subscriber).not_to accept(Registration::CreateMessage.new(registration:))
  end

  describe '#perform' do
    subject(:perform) { subscriber.perform }

    let(:subscriber) { described_class.new(message) }
    let(:message) { Registration::CreateMessage.new(registration:) }
    let(:registration) { create(:registration, event:) }
    let(:event) { create(:event, :published) }

    before(:each) do
      create(:event_role_config, :with_discord_role_id, event:)
    end

    it "adds the player to the event's Discord role" do
      discord_user_id = registration.player.discord_user_id
      discord_role_id = event.role_config.discord_role_id
      add_guild_member_role = stub_discord_add_guild_member_role(
        event.discord_guild_id, user_id: discord_user_id, role_id: discord_role_id
      )

      perform
      expect(add_guild_member_role).to have_been_requested.once
    end
  end
end
