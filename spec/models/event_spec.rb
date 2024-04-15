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
end
