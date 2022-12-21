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
class UserSession < ApplicationRecord
  DURATION = 3.months

  belongs_to :user, inverse_of: :sessions

  has_encrypted :creation_ip, :current_ip, type: :inet, blind_index: true

  before_create do
    self.expires_at = Time.current + DURATION
  end

  # Retrieves a session by an authentication token.
  # Returns nil if the token is invalid, has expired, or has been revoked.
  #
  # @param token [String, nil]
  # @return [UserSession, nil] the session associated with the token, or nil if the token is invalid
  def self.find_by_token(token)
    session = find_signed(token, purpose: :authentication)
    return if session.nil? || session.expired? || session.revoked?

    session
  rescue ActiveRecord::RecordNotFound
    nil # Session deleted from DB
  end

  # @return [Boolean] true if the session has expired
  def expired?
    expires_at.present? && expires_at.past?
  end

  # @return [Boolean] true if the session has been revoked
  def revoked?
    revoked_at.present?
  end

  # @return [Boolean]
  def revoke!
    revoked? || update!(revoked_at: Time.current)
  end

  # @return [String] a token that can be used to authenticate the session
  def token
    signed_id(purpose: :authentication)
  end
end
