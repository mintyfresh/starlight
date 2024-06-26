# frozen_string_literal: true

class CreateEventRoleConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :event_role_configs do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.bigint     :discord_role_id
      t.string     :name, null: false
      t.string     :permissions, null: false, default: '0'
      t.integer    :colour, null: false, default: 0x000000
      t.boolean    :hoist, null: false, default: false
      t.boolean    :mentionable, null: false, default: false
      t.interval   :cleanup_delay
      t.timestamps
    end
  end
end
