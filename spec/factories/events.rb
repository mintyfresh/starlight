# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                          :bigint           not null, primary key
#  type                        :string
#  created_by_id               :bigint           not null
#  discord_guild_id            :bigint           not null
#  name                        :string           not null
#  slug                        :string           not null
#  location                    :string
#  description                 :string
#  time_zone                   :string
#  starts_at_date              :date
#  starts_at_time              :time
#  ends_at_date                :date
#  ends_at_time                :time
#  registration_starts_at_date :date
#  registration_starts_at_time :time
#  registration_ends_at_date   :date
#  registration_ends_at_time   :time
#  registrations_count         :integer          default(0), not null
#  registrations_limit         :integer
#  published_at                :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_events_on_created_by_id  (created_by_id)
#  index_events_on_slug           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
FactoryBot.define do
  factory :event do
    created_by factory: :user
    discord_guild_id { Faker::Number.number(digits: 18) }
    name { Faker::Book.title.truncate(Event::NAME_MAX_LENGTH) }
    location { Faker::Address.full_address.truncate(Event::LOCATION_MAX_LENGTH) }
    description { Faker::Hipster.paragraph.truncate(Event::DESCRIPTION_MAX_LENGTH) }
    time_zone { TZInfo::Timezone.all_identifiers.sample }
    starts_at { Faker::Time.forward(days: 30) }
    ends_at { starts_at + 2.days }
    registration_starts_at { starts_at - 1.week }
    registration_ends_at { starts_at - 1.day }

    trait :with_registrations_limit do
      registrations_limit { Faker::Number.number(digits: 2) }
    end

    trait :published do
      published_at { Time.current }
    end
  end
end
