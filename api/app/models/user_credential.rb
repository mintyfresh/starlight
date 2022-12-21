# frozen_string_literal: true

# == Schema Information
#
# Table name: user_credentials
#
#  id          :bigint           not null, primary key
#  type        :string           not null
#  user_id     :bigint           not null
#  external_id :string
#  data        :jsonb
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
class UserCredential < ApplicationRecord
  belongs_to :user, inverse_of: :credentials

  has_unique_attribute :external_id, index: 'index_user_credentials_on_type_and_external_id'
  has_unique_attribute :user, index: 'index_user_credentials_on_type_and_user_id'

  validates :type, presence: { strict: true }

  # @abstract
  # @param credential [String]
  # @return [User, nil] the user associated with the credential, or nil if the credential is invalid
  def authenticate?(_)
    raise NotImplementedError, "#{self.class.name}#authenticate? is not implemented"
  end
end
