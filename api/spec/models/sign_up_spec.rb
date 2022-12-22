# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignUp do
  subject(:sign_up) { build(:sign_up) }

  it 'has a valid factory' do
    expect(sign_up).to be_valid
  end

  it 'is invalid without an email' do
    sign_up.email = nil
    expect(sign_up).to be_invalid
  end

  it 'is invalid when the email is invalid' do
    sign_up.email = 'invalid'
    expect(sign_up).to be_invalid
  end

  it 'is invalid without a display name' do
    sign_up.display_name = nil
    expect(sign_up).to be_invalid
  end

  it 'is invalid when the display name is invalid' do
    sign_up.display_name = "\0"
    expect(sign_up).to be_invalid
  end

  it 'is invalid without a password' do
    sign_up.password = nil
    expect(sign_up).to be_invalid
  end

  it 'is invalid when the password is too short' do
    sign_up.password = 'a' * 7
    expect(sign_up).to be_invalid
  end

  it 'is invalid when the password is too long' do
    sign_up.password = 'a' * 129
    expect(sign_up).to be_invalid
  end

  it 'is strictly invalid without an IP' do
    sign_up.ip = nil
    expect { sign_up.validate }.to raise_error(ActiveModel::StrictValidationFailed)
  end

  describe '#call' do
    subject(:call) { sign_up.call }

    it 'creates a user with the email and display name' do
      expect(call.user).to have_attributes(email: sign_up.email, display_name: sign_up.display_name)
    end

    it 'creates a user with a password credential with the password' do
      expect(call.user.authenticate(UserCredential::Password, sign_up.password)).to be_truthy
    end

    it 'returns nil if the form is invalid', :aggregate_failures do
      sign_up.email = nil
      expect(call).to be_nil
      expect(sign_up.errors).to be_of_kind(:email, :blank)
    end

    it 'does not create a user if the form is invalid' do
      sign_up.email = nil
      expect { call }.not_to change { User.count }
    end

    it 'returns nil if the email is already taken', :aggregate_failures do
      sign_up.email = create(:user).email
      expect(call).to be_nil
      expect(sign_up.errors).to be_of_kind(:email, :taken)
    end

    it 'returns nil if the display name is already taken', :aggregate_failures do
      sign_up.display_name = create(:user).display_name
      expect(call).to be_nil
      expect(sign_up.errors).to be_of_kind(:display_name, :taken)
    end
  end
end
