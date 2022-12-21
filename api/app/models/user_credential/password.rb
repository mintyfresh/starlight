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
class UserCredential
  class Password < UserCredential
    ARGON2_TIME_COST   = Rails.application.config.argon2.time_cost
    ARGON2_MEMORY_COST = Rails.application.config.argon2.memory_cost
    ARGON2_SECRET      = Rails.application.config.argon2.secret
    private_constant :ARGON2_SECRET

    attribute :password, :binary

    store_accessor :secret_data, :password_hash, :last_changed_at

    validates :external_id, absence: true
    validates :password, length: { minimum: 8, maximum: 128 }, allow_nil: true
    validates :password, presence: { on: :create }

    before_save if: :password_changed? do
      self.password_hash   = password && password_service.create(password)
      self.last_changed_at = Time.current.to_f
    end

    # @param password [String, nil] the password to be validated
    # @return [User, nil] the user if the password is correct, or nil if the password is invalid
    def authenticate(password)
      user if password_hash_matches?(password)
    end

    # @return [Time, nil] the timestamp of the last password change, or nil
    def last_changed_at
      (timestamp = super) && Time.zone.at(timestamp)
    end

  private

    # @param password [String, nil] the password to be validated
    # @return [Boolean] true if the password is correct, false otherwise
    def password_hash_matches?(password)
      return false if password.blank? || password_hash.blank?

      Argon2::Password.verify_password(password, password_hash, ARGON2_SECRET)
    end

    # @return [Argon2::Password]
    def password_service
      Argon2::Password.new(
        t_cost: ARGON2_TIME_COST,
        m_cost: ARGON2_MEMORY_COST,
        secret: ARGON2_SECRET
      )
    end
  end
end
