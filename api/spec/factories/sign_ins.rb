# frozen_string_literal: true

FactoryBot.define do
  factory :sign_in do
    email { user.email }
    password { user.credentials.first.password }

    after(:build) do |sign_in|
      sign_in.ip ||= Faker::Internet.ip_v4_address
    end

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
