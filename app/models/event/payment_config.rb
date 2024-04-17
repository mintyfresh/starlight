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
class Event
  class PaymentConfig < ApplicationRecord
    belongs_to :event, inverse_of: :payment_config

    validates :currency, presence: true

    monetize :price_cents, with_model_currency: :currency, numericality: { greater_than: 0 }
  end
end
