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

RSpec.describe ConstructedEvent do
  subject(:event) { build(:constructed_event) }

  it 'has a valid factory' do
    expect(event).to be_valid
      .and be_a(described_class)
      .and have_attributes(type: 'ConstructedEvent')
  end

  it 'permits decklists' do
    expect(event).to be_decklist_permitted
  end

  it 'does not require a decklist by default' do
    expect(event).not_to be_decklist_required
  end

  context 'with a decklist config' do
    subject(:event) { build(:constructed_event, :with_decklist_config) }

    it 'requires a decklist' do
      expect(event).to be_decklist_required
    end

    it 'does not require a decklist if the config does not require one' do
      event.decklist_config.decklist_required = false
      expect(event).not_to be_decklist_required
    end
  end
end
