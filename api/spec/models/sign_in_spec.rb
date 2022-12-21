# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignIn do
  subject(:sign_in) { build(:sign_in) }

  it 'has a valid factory' do
    expect(sign_in).to be_valid
  end

  it 'is invalid without an email' do
    sign_in.email = nil
    expect(sign_in).to be_invalid
  end

  it 'is invalid without a password' do
    sign_in.password = nil
    expect(sign_in).to be_invalid
  end

  it 'is strictly invalid without an IP' do
    sign_in.ip = nil
    expect { sign_in.validate }.to raise_error(ActiveModel::StrictValidationFailed)
  end

  describe '#call' do
    subject(:call) { sign_in.call }

    it 'returns a session for the user if the email and password are correct', :aggregate_failures do
      user = User.find_by(email: sign_in.email)
      expect(call.user).to eq(user)
      expect(call.creation_ip).to eq(sign_in.ip)
      expect(call.current_ip).to eq(sign_in.ip)
    end

    it 'returns nil if the form is invalid', :aggregate_failures do
      sign_in.email = nil
      expect(call).to be_nil
      expect(sign_in.errors).to be_of_kind(:email, :blank)
    end

    it 'returns nil if the email is incorrect', :aggregate_failures do
      sign_in.email = 'incorrect-email'
      expect(call).to be_nil
      expect(sign_in.errors).to be_of_kind(:base, :incorrect_email_or_password)
    end

    it 'returns nil if the password is incorrect', :aggregate_failures do
      sign_in.password = 'incorrect-password'
      expect(call).to be_nil
      expect(sign_in.errors).to be_of_kind(:base, :incorrect_email_or_password)
    end
  end
end
