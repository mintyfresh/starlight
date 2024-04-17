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
require 'rails_helper'

RSpec.describe Event::CheckInConfig do
  subject(:config) { build(:event_check_in_config) }

  it 'has a valid factory' do
    expect(config).to be_valid
  end

  it 'is invalid without an event' do
    config.event = nil
    expect(config).to be_invalid
  end

  it 'sets the time zone from the event' do
    config.time_zone = nil
    config.valid?
    expect(config.time_zone).to eq(config.event.time_zone)
  end

  it 'is invalid without a starts at' do
    config.starts_at = nil
    expect(config).to be_invalid
  end

  it 'is valid without an ends at' do
    config.ends_at = nil
    expect(config).to be_valid
  end

  it 'is invalid with a starts at after the ends at' do
    config.ends_at = config.starts_at - 1.hour
    expect(config).to be_invalid
  end

  it 'is invalid with a starts at after the event starts at' do
    config.starts_at = config.event.starts_at + 1.hour
    expect(config).to be_invalid
  end

  it 'is invalid with an ends at after the event ends at' do
    config.ends_at = config.event.ends_at + 1.hour
    expect(config).to be_invalid
  end
end
