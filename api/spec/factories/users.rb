# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  email_ciphertext :binary           not null
#  email_bidx       :binary           not null
#  display_name     :citext           not null
#  posts_count      :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_display_name  (display_name) UNIQUE
#  index_users_on_email_bidx    (email_bidx) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(name: display_name) }
    sequence(:display_name) { |n| "#{Faker::Internet.user_name} #{n}" }

    trait :with_password do
      transient do
        password { Faker::Internet.password }
      end

      after(:build) do |user, e|
        user.credentials << build(:user_password_credential, user:, password: e.password)
      end
    end
  end
end
