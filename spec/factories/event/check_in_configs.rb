# frozen_string_literal: true

# == Schema Information
#
# Table name: event_check_in_configs
#
#  id             :bigint           not null, primary key
#  event_id       :bigint           not null
#  time_zone      :string
#  starts_at_date :date             not null
#  starts_at_time :time             not null
#  ends_at_date   :date
#  ends_at_time   :time
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_event_check_in_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :event_check_in_config, class: 'Event::CheckInConfig' do
    event
    time_zone { event.time_zone }
    starts_at { event.starts_at - 1.week }

    trait :with_ends_at do
      ends_at { event.starts_at - 1.day }
    end
  end
end
