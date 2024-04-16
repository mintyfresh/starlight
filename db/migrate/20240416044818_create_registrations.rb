# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.belongs_to :player, null: false, foreign_key: { to_table: :users }
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps

      t.index %i[event_id player_id], unique: true
    end
  end
end
