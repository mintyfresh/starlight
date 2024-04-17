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
FactoryBot.define do
  factory :event_payment_config, class: 'Event::PaymentConfig' do
    event
    currency { %w[CAD USD EUR].sample }
    price { Faker::Commerce.price }
  end
end
