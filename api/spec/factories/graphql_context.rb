# frozen_string_literal: true

FactoryBot.define do
  factory :graphql_context, class: 'Hash' do
    skip_create
    initialize_with { attributes }

    ip { Faker::Internet.ip_v4_address }
    remote_ip { Faker::Internet.ip_v4_address }
    request_id { SecureRandom.uuid }
    user_agent { Faker::Internet.user_agent }
    current_session { current_user && create(:user_session, user: current_user) }

    transient do
      current_user { nil }
    end

    trait :signed_in do
      current_user { create(:user) }
    end
  end
end
