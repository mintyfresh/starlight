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
FactoryBot.define do
  factory :user_session do
    association :user

    creation_ip { Faker::Internet.ip_v4_address }
    current_ip { Faker::Internet.ip_v4_address }

    trait :expired do
      expires_at { 1.minute.ago }
    end

    trait :revoked do
      revoked_at { Time.current }
    end
  end
end
