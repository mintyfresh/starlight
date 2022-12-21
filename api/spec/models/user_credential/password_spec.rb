# frozen_string_literal: true

# == Schema Information
#
# Table name: user_credentials
#
#  id          :bigint           not null, primary key
#  type        :string           not null
#  user_id     :bigint           not null
#  external_id :string
#  secret_data :jsonb
#  expires_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_credentials_on_type_and_external_id  (type,external_id) UNIQUE
#  index_user_credentials_on_type_and_user_id      (type,user_id) UNIQUE
#  index_user_credentials_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserCredential::Password do
  subject(:user_credential) { build(:user_password_credential) }

  it 'has a valid factory' do
    expect(user_credential).to be_valid
  end

  it 'is invalid without a password during creation' do
    user_credential.password = nil
    expect(user_credential).to be_invalid
  end

  it 'generates a password hash during creation' do
    user_credential.save!
    expect(user_credential.password_hash).to be_present
  end

  it 'stores a timestamp of the last password change' do
    freeze_time do
      user_credential.save!
      expect(user_credential.last_changed_at).to eq(Time.current)
    end
  end

  describe '#authenticate' do
    subject(:user_credential) { create(:user_password_credential) }

    it 'returns the user if the password is correct' do
      expect(user_credential.authenticate(user_credential.password)).to eq(user_credential.user)
    end

    it 'returns nil if the password is incorrect' do
      expect(user_credential.authenticate('wrong_password')).to be_nil
    end

    it 'returns nil if the password is nil' do
      expect(user_credential.authenticate(nil)).to be_nil
    end
  end
end
