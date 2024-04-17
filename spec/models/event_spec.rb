# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                          :bigint           not null, primary key
#  type                        :string
#  created_by_id               :bigint           not null
#  discord_guild_id            :bigint           not null
#  name                        :string           not null
#  slug                        :string           not null
#  location                    :string
#  description                 :string
#  time_zone                   :string
#  starts_at_date              :date
#  starts_at_time              :time
#  ends_at_date                :date
#  ends_at_time                :time
#  registration_starts_at_date :date
#  registration_starts_at_time :time
#  registration_ends_at_date   :date
#  registration_ends_at_time   :time
#  registrations_count         :integer          default(0), not null
#  registrations_limit         :integer
#  published_at                :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#  index_events_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
require 'rails_helper'

RSpec.describe Event do
  subject(:event) { build(:event) }

  it 'has a valid factory' do
    expect(event).to be_valid
  end

  it 'is invalid without a creator' do
    event.created_by = nil
    expect(event).to be_invalid
  end

  it 'is invalid without a Discord guild ID' do
    event.discord_guild_id = nil
    expect(event).to be_invalid
  end

  it 'is invalid without a name' do
    event.name = nil
    expect(event).to be_invalid
  end

  it 'is invalid when the name is too long' do
    event.name = 'a' * (Event::NAME_MAX_LENGTH + 1)
    expect(event).to be_invalid
  end

  it 'is valid without a location' do
    event.location = nil
    expect(event).to be_valid
  end

  it 'is invalid when the location is too long' do
    event.location = 'a' * (Event::LOCATION_MAX_LENGTH + 1)
    expect(event).to be_invalid
  end

  it 'is valid without a description' do
    event.description = nil
    expect(event).to be_valid
  end

  it 'is invalid when the description is too long' do
    event.description = 'a' * (Event::DESCRIPTION_MAX_LENGTH + 1)
    expect(event).to be_invalid
  end

  it 'is valid without a time zone' do
    event.time_zone = nil
    expect(event).to be_valid
  end

  it 'is invalid with an invalid time zone' do
    event.time_zone = 'invalid'
    expect(event).to be_invalid
  end

  it 'is valid without a starts at date' do
    event.starts_at_date = nil
    expect(event).to be_valid
  end

  it 'is valid without a starts at time' do
    event.starts_at_time = nil
    expect(event).to be_valid
  end

  it 'is valid without an ends at date' do
    event.ends_at_date = nil
    expect(event).to be_valid
  end

  it 'is valid without an ends at time' do
    event.ends_at_time = nil
    expect(event).to be_valid
  end

  it 'is invalid when the event starts after it ends' do
    event.starts_at = event.ends_at + 1.day
    expect(event).to be_invalid
  end

  it 'is valid without a registration starts at date' do
    event.registration_starts_at_date = nil
    expect(event).to be_valid
  end

  it 'is invalid when the registration starts after the event starts' do
    event.registration_starts_at = event.starts_at + 1.day
    expect(event).to be_invalid
  end

  it 'is valid without a registration ends at date' do
    event.registration_ends_at_date = nil
    expect(event).to be_valid
  end

  it 'is invalid when the registration starts after it ends' do
    event.registration_starts_at = event.registration_ends_at + 1.day
    expect(event).to be_invalid
  end

  it 'is invalid when the registrations limit is negative' do
    event.registrations_limit = -1
    expect(event).to be_invalid
  end

  context 'when published' do
    subject(:event) { build(:event, :published) }

    it 'has a valid factory' do
      expect(event).to be_valid
        .and be_published
    end

    it 'is invalid without a time zone' do
      event.time_zone = nil
      expect(event).to be_invalid
    end

    it 'is invalid without a starts at' do
      event.starts_at = nil
      expect(event).to be_invalid
    end

    it 'is invalid without an ends at' do
      event.ends_at = nil
      expect(event).to be_invalid
    end
  end

  describe '#publish' do
    subject(:publish) { event.publish }

    let(:event) { create(:event) }

    it 'publishes the event' do
      expect { event.publish }.to change { event.published? }.from(false).to(true)
    end

    it 'sets the published at timestamp', :freeze_time do
      expect { event.publish }.to change { event.published_at }.from(nil).to(Time.current)
    end

    it 'returns true' do
      expect(publish).to be(true)
    end

    it 'publishes a Event::PublishMessage' do
      expect { publish }.to have_published(described_class, :publish).with(event:)
    end

    context 'when the event is already published' do
      let(:event) { create(:event, :published) }

      it 'does not change the published at timestamp' do
        expect { event.publish }.not_to change { event.published_at }
      end
    end

    context 'when the event cannot be published' do
      let(:event) { create(:event, time_zone: nil) }

      it 'returns false' do
        expect(publish).to be(false)
      end

      it 'sets an error on the record' do
        publish
        expect(event.errors).to be_of_kind(:time_zone, :blank)
      end
    end
  end

  describe '#open_for_registration?' do
    let(:event) { build(:event, :published, :open_for_registration) }

    it 'returns true when the event is published and open for registration' do
      expect(event).to be_open_for_registration
    end

    it 'returns false when the event is not published' do
      event.published_at = nil
      expect(event).not_to be_open_for_registration
    end

    it 'returns false when the registration starts in the future' do
      event.registration_starts_at = 1.day.from_now
      expect(event).not_to be_open_for_registration
    end

    it 'returns false when the registration ends in the past' do
      event.registration_ends_at = 1.day.ago
      expect(event).not_to be_open_for_registration
    end

    it 'returns false when the event has ended' do
      event.ends_at = 1.day.ago
      expect(event).not_to be_open_for_registration
    end
  end

  describe '#open_for_check_in?' do
    let(:event) { build(:event, :published, :open_for_check_in) }

    it 'returns true when the event is published and open for check-in' do
      expect(event).to be_open_for_check_in
    end

    it 'returns false when the event is not published' do
      event.published_at = nil
      expect(event).not_to be_open_for_check_in
    end

    it 'returns false when the event has started' do
      event.starts_at = 1.day.ago
      expect(event).not_to be_open_for_check_in
    end

    it 'returns false when check-in has not started' do
      event.check_in_config.starts_at = 1.day.from_now
      expect(event).not_to be_open_for_check_in
    end

    it 'returns false when check-in has ended' do
      event.check_in_config.ends_at = 1.day.ago
      expect(event).not_to be_open_for_check_in
    end

    it 'returns false when the even does not enable check-in' do
      event.check_in_config = nil
      expect(event).not_to be_open_for_check_in
    end
  end

  describe '#register' do
    subject(:register) { event.register(player) }

    let(:event) { create(:event, :published, :open_for_registration) }
    let(:player) { create(:user) }

    it 'registers the player for the event' do
      expect { register }.to change { event.registered?(player) }.from(false).to(true)
    end

    it 'returns the registration' do
      expect(register).to be_a(Registration)
        .and have_attributes(event:, player:, created_by: player)
    end

    context 'with a decklist in the attributes' do
      subject(:register) { event.register(player, { decklist_attributes: }) }

      let(:decklist_attributes) { attributes_for(:decklist) }

      it 'registers the player for the event' do
        expect { register }.to change { event.registered?(player) }.from(false).to(true)
      end

      it 'creates a decklist for the registration' do
        expect(register.decklist).to be_a(Decklist)
          .and have_attributes(decklist_attributes)
      end
    end

    context 'when the player is already registered' do
      let!(:registration) { create(:registration, event:, player:) }

      it 'does not create a new registration' do
        expect { register }.not_to change { event.registrations.count }
      end

      it 'returns the existing registration' do
        expect(register).to eq(registration)
      end

      context 'with a decklist in the attributes' do
        subject(:register) { event.register(player, { decklist_attributes: }) }

        let(:decklist_attributes) { attributes_for(:decklist) }

        it 'updates the existing registration with the decklist', :aggregate_failures do
          expect { register }.to change { registration.reload.decklist }
          expect(register.decklist).to have_attributes(decklist_attributes)
        end
      end
    end

    context 'when the event is not open for registration' do
      let(:event) { create(:event, :draft) }

      it 'does not register the player' do
        expect { register }.not_to change { event.registered?(player) }
      end

      it 'returns nil and sets an error on the record', :aggregate_failures do
        expect(register).to be_nil
        expect(event.errors).to be_of_kind(:base, :not_open_for_registration)
      end
    end
  end

  describe '#check_in' do
    subject(:check_in) { event.check_in(player) }

    let(:event) { create(:event, :published, :with_registrations, :open_for_check_in) }
    let(:player) { event.registered_players.sample }

    it 'checks in the player for the event' do
      expect { check_in }.to change { event.checked_in?(player) }.from(false).to(true)
    end

    it 'returns the check-in' do
      registration = event.registrations.find_by(player:)
      expect(check_in).to be_a(CheckIn).and have_attributes(registration:, created_by: player)
    end

    context 'when the player is not registered' do
      let(:player) { create(:user) }

      it 'does not check in the player' do
        expect { check_in }.not_to change { event.checked_in?(player) }
      end

      it 'returns nil and sets an error on the record', :aggregate_failures do
        expect(check_in).to be_nil
        expect(event.errors).to be_of_kind(:base, :not_registered)
      end
    end

    context 'when the event is not open for check-in' do
      let(:event) { create(:event, :published) }

      it 'does not check in the player' do
        expect { check_in }.not_to change { event.checked_in?(player) }
      end

      it 'returns nil and sets an error on the record', :aggregate_failures do
        expect(check_in).to be_nil
        expect(event.errors).to be_of_kind(:base, :not_open_for_check_in)
      end
    end
  end
end
