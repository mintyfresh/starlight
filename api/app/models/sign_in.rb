# frozen_string_literal: true

class SignIn < ApplicationModel
  attribute :email, :string
  attribute :password, :string
  attribute :ip, :string

  validates :email, presence: true
  validates :password, presence: true
  validates :ip, presence: { strict: true }

  # @return [UserSession, nil]
  def call
    return if invalid?

    user = User.find_by(email:)
    errors.add(:base, :incorrect_email_or_password) and return if user.nil?

    user = user.authenticate(UserCredential::Password, password)
    errors.add(:base, :incorrect_email_or_password) and return if user.nil?

    user.sessions.create!(creation_ip: ip, current_ip: ip)
  end
end
