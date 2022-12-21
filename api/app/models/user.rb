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
class User < ApplicationRecord
  DISPLAY_NAME_CHAR       = /[a-z0-9\-_. ]/i
  DISPLAY_NAME_FORMAT     = /\A#{DISPLAY_NAME_CHAR}+\z/o
  DISPLAY_NAME_MAX_LENGTH = 30

  has_encrypted :email, blind_index: { expression: -> (email) { email&.downcase } }

  has_unique_attribute :email, index: 'index_users_on_email_bidx'
  has_unique_attribute :display_name

  has_many :credentials, class_name: 'UserCredential', dependent: :destroy, inverse_of: :user

  has_many :authored_topics, class_name: 'Topic', foreign_key: :author_id,
                             inverse_of: :author, dependent: :restrict_with_error

  validates :email, email: true, presence: true
  validates :display_name, format: { with: DISPLAY_NAME_FORMAT }, length: { maximum: DISPLAY_NAME_MAX_LENGTH }

  # @param type [Class<UserCredential>] the type of credential to authenticate with
  # @param credential [String] the user input credential
  # @return [self, nil] the authenticated user, or nil if the credential is invalid
  def authenticate(type, credential)
    credentials.find_by(type: type.sti_name)&.authenticate(credential)
  end
end
