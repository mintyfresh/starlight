# frozen_string_literal: true

FactoryBot.define do
  factory :sign_in do
    email { user.email }
    password { user.credentials.first.password }
    ip { Faker::Internet.ip_v4_address }

    transient do
      user { create(:user, :with_password) }
    end

    trait :invalid do
      email { nil }
    end

    trait :incorrect_password do
      password { 'incorrect-password' }
    end
  end
end
