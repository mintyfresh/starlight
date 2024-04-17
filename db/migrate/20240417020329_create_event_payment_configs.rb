# frozen_string_literal: true

class CreateEventPaymentConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :event_payment_configs do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.string     :currency, null: false
      t.integer    :price_cents, null: false
      t.timestamps

      t.check_constraint 'price_cents > 0'
    end
  end
end
