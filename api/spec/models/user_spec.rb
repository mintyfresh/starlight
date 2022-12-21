# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  email_ciphertext :binary           not null
#  email_bidx       :binary           not null
#  display_name     :citext           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_display_name  (display_name) UNIQUE
#  index_users_on_email_bidx    (email_bidx) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user.email = nil
    expect(user).to be_invalid
  end

  it 'is invalid when the email is not unique' do
    create(:user, email: user.email)
    user.save
    expect(user.errors).to be_of_kind(:email, :taken)
  end

  it 'is invalid when the email is not a valid email' do
    user.email = 'not an email'
    expect(user).to be_invalid
  end

  it 'is invalid without a display name' do
    user.display_name = nil
    expect(user).to be_invalid
  end

  it 'is invalid when the display name is not unique' do
    create(:user, display_name: user.display_name)
    user.save
    expect(user.errors).to be_of_kind(:display_name, :taken)
  end

  it 'is invalid when the display name contains invalid characters' do
    user.display_name = "invalid\0name"
    expect(user).to be_invalid
  end

  it 'is invalid when the display name is too long' do
    user.display_name = 'a' * 31
    expect(user).to be_invalid
  end

  describe '#authenticate' do
    context 'when the user has a password credential' do
      let(:user) { create(:user, :with_password, password:) }
      let(:password) { Faker::Internet.password }

      it 'returns the user when the password is correct' do
        expect(user.authenticate(UserCredential::Password, password)).to eq(user)
      end

      it 'returns nil when the password is incorrect' do
        expect(user.authenticate(UserCredential::Password, 'wrong_password')).to be_nil
      end

      it 'returns nil when the user does not have a password credential' do
        user.credentials.destroy_all
        expect(user.authenticate(UserCredential::Password, password)).to be_nil
      end
    end
  end
end
