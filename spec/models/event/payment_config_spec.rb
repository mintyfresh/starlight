# frozen_string_literal: true

# == Schema Information
#
# Table name: event_payment_configs
#
#  id          :bigint           not null, primary key
#  event_id    :bigint           not null
#  currency    :string           not null
#  price_cents :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_event_payment_configs_on_event_id  (event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require 'rails_helper'

RSpec.describe Event::PaymentConfig do
  subject(:config) { build(:event_payment_config) }

  it 'has a valid factory' do
    expect(config).to be_valid
  end

  it 'is invalid without an event' do
    config.event = nil
    expect(config).to be_invalid
  end

  it 'is invalid without a currency' do
    config.currency = nil
    expect(config).to be_invalid
  end

  it 'is invalid without a price' do
    config.price = nil
    expect(config).to be_invalid
  end

  it 'is invalid with a negative price' do
    config.price = -1
    expect(config).to be_invalid
  end

  it 'is invalid with a price of zero' do
    config.price = 0
    expect(config).to be_invalid
  end
end
