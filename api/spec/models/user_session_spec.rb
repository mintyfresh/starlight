# frozen_string_literal: true

# == Schema Information
#
# Table name: user_sessions
#
#  id                     :bigint           not null, primary key
#  user_id                :bigint           not null
#  creation_ip_ciphertext :binary
#  creation_ip_bidx       :binary
#  current_ip_ciphertext  :binary
#  current_ip_bidx        :binary
#  expires_at             :datetime         not null
#  revoked_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_creation_ip_bidx  (creation_ip_bidx)
#  index_user_sessions_on_current_ip_bidx   (current_ip_bidx)
#  index_user_sessions_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserSession do
  subject(:session) { build(:user_session) }

  it 'has a valid factory' do
    expect(session).to be_valid
  end

  it 'is invalid without a user' do
    session.user = nil
    expect(session).to be_invalid
  end

  it 'sets an expiry upon creation' do
    freeze_time do
      session.save!
      expect(session.expires_at).to eq(Time.current + described_class::DURATION)
    end
  end

  describe '#revoke!' do
    subject(:session) { create(:user_session) }

    it 'returns true' do
      expect(session.revoke!).to be(true)
    end

    it 'sets a timestamp for the revocation' do
      freeze_time do
        expect { session.revoke! }.to change { session.revoked_at }.to(Time.current)
      end
    end

    context 'when the session is already revoked' do
      subject(:session) { create(:user_session, :revoked) }

      it 'returns true' do
        expect(session.revoke!).to be(true)
      end

      it 'does not change the revocation timestamp' do
        expect { session.revoke! }.not_to change { session.revoked_at }
      end
    end
  end

  describe '.find_by_token' do
    subject(:session) { create(:user_session) }

    it 'returns the session with the given token' do
      expect(described_class.find_by_token(session.token)).to eq(session)
    end

    it 'returns nil if the token is invalid' do
      expect(described_class.find_by_token('invalid_token')).to be_nil
    end

    it 'returns nil if the session has expired' do
      session.update!(expires_at: 1.day.ago)
      expect(described_class.find_by_token(session.token)).to be_nil
    end

    it 'returns nil if the session has been revoked' do
      session.revoke!
      expect(described_class.find_by_token(session.token)).to be_nil
    end

    it 'returns nil if the session has been deleted' do
      token = session.token
      session.destroy!
      expect(described_class.find_by_token(token)).to be_nil
    end
  end
end
