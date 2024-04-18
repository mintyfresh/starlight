# frozen_string_literal: true

class CreateEventDecklistConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :event_decklist_configs do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.string     :visibility, null: false
      t.boolean    :decklist_required, null: false, default: false
      t.string     :format
      t.string     :format_behaviour
      t.timestamps
    end
  end
end
