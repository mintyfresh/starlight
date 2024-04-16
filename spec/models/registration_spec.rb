# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id            :bigint           not null, primary key
#  event_id      :bigint           not null
#  player_id     :bigint           not null
#  created_by_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_registrations_on_created_by_id           (created_by_id)
#  index_registrations_on_event_id                (event_id)
#  index_registrations_on_event_id_and_player_id  (event_id,player_id) UNIQUE
#  index_registrations_on_player_id               (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (player_id => users.id)
#
require 'rails_helper'

RSpec.describe Registration do
  subject(:registration) { build(:registration) }

  it 'has a valid factory' do
    expect(registration).to be_valid
  end

  it 'is invalid without an event' do
    registration.event = nil
    expect(registration).to be_invalid
  end

  it 'is invalid without a player' do
    registration.player = nil
    expect(registration).to be_invalid
  end

  it 'is invalid without a creator' do
    registration.created_by = nil
    expect(registration).to be_invalid
  end
end
