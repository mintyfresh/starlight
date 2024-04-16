# frozen_string_literal: true

# == Schema Information
#
# Table name: event_role_configs
#
#  id              :bigint           not null, primary key
#  event_id        :bigint           not null
#  discord_role_id :bigint
#  name            :string           not null
#  permissions     :string           default("0"), not null
#  colour          :integer          default(0), not null
#  hoist           :boolean          default(FALSE), not null
#  mentionable     :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_event_role_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :event_role_config, class: 'Event::RoleConfig' do
    event
    name { Faker::Lorem.word }

    trait :with_discord_role_id do
      discord_role_id { Faker::Number.number(digits: 18) }
    end

    trait :with_colour do
      colour { rand(0x000000..0xFFFFFF) }
    end

    trait :hoist do
      hoist { true }
    end

    trait :mentionable do
      mentionable { true }
    end
  end
end
