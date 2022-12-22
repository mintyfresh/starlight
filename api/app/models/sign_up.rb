# frozen_string_literal: true

class SignUp < ApplicationModel
  attribute :email, :string
  attribute :display_name, :string
  attribute :password, :string
  attribute :ip, :string

  validates :email, presence: true, email: true
  validates :display_name, format: { with: User::DISPLAY_NAME_FORMAT },
                           length: { maximum: User::DISPLAY_NAME_MAX_LENGTH }
  validates :password, length: { minimum: 8, maximum: 128 }
  validates :ip, presence: { strict: true }

  # @return [UserSession, nil]
  def call
    return if invalid?

    user = User.new(email:, display_name:)
    user.credentials << UserCredential::Password.new(password:)
    errors.copy!(user.errors) and return unless user.save

    user.sessions.create!(creation_ip: ip, current_ip: ip)
  end
end
