# frozen_string_literal: true

# == Schema Information
#
# Table name: event_announcement_configs
#
#  id                 :bigint           not null, primary key
#  event_id           :bigint           not null
#  discord_channel_id :bigint           not null
#  discord_message_id :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_event_announcement_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :event_announcement_config, class: 'Event::AnnouncementConfig' do
    event

    discord_channel_id { Faker::Number.number(digits: 18) }

    trait :with_discord_message_id do
      discord_message_id { Faker::Number.number(digits: 18) }
    end
  end
end
