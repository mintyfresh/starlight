# frozen_string_literal: true

FactoryBot.define do
  factory :sign_up do
    email { Faker::Internet.email(name: display_name) }
    sequence(:display_name) { |n| "#{Faker::Internet.user_name} #{n}" }
    password { Faker::Internet.password }

    after(:build) do |sign_up|
      sign_up.ip ||= Faker::Internet.ip_v4_address
    end

    trait :invalid do
      email { 'not an email' }
    end
  end
end
