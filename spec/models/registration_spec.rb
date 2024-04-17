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

  it 'is not checked-in by default' do
    expect(registration).not_to be_checked_in
  end

  context 'with a check-in' do
    subject(:registration) { build(:registration, :with_check_in) }

    it 'has a valid factory' do
      expect(registration).to be_valid
    end

    it 'is checked in' do
      expect(registration).to be_checked_in
    end
  end

  describe '#check_in!' do
    subject(:check_in!) { registration.check_in!(created_by: creator) }

    let(:registration) { create(:registration) }
    let(:creator) { create(:user) }

    it 'marks the registration as checked in' do
      expect { check_in! }.to change { registration.checked_in? }.from(false).to(true)
    end

    it 'returns the check-in' do
      expect(check_in!).to be_a(CheckIn).and have_attributes(
        registration: registration,
        created_by:   creator
      )
    end

    context 'when the registration is already checked in' do
      let!(:check_in) { create(:check_in, registration:) }

      it 'returns the existing check-in' do
        expect(check_in!).to eq(check_in)
      end

      it 'does not charge the creator on the check-in' do
        expect { check_in! }.not_to change { check_in.reload.created_by }
      end
    end
  end
end
