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
FactoryBot.define do
  factory :user_password_credential, class: 'UserCredential::Password', parent: :user_credential do
    type { UserCredential::Password.sti_name }
    password { Faker::Internet.password }
  end
end
