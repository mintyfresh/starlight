# frozen_string_literal: true

# == Schema Information
#
# Table name: event_decklist_configs
#
#  id                :bigint           not null, primary key
#  event_id          :bigint           not null
#  visibility        :string           not null
#  decklist_required :boolean          default(FALSE), not null
#  format            :string
#  format_behaviour  :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_event_decklist_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :event_decklist_config, class: 'Event::DecklistConfig' do
    event factory: :constructed_event
    visibility { Event::DecklistConfig::VISIBILITIES.sample }
    decklist_required { true }
    format { Event::DecklistConfig::FORMATS.sample }
    format_behaviour { 'reject_invalid' }

    trait :decklist_required do
      decklist_required { true }
    end

    trait :decklist_optional do
      decklist_required { false }
    end

    trait :reject_invalid do
      format_behaviour { 'reject_invalid' }
    end

    trait :require_approval do
      format_behaviour { 'require_approval' }
    end

    trait :accept_invalid do
      format_behaviour { 'accept_invalid' }
    end
  end
end
