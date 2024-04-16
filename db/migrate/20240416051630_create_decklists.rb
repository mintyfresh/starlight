# frozen_string_literal: true

class CreateDecklists < ActiveRecord::Migration[7.1]
  def change
    create_table :decklists do |t|
      t.belongs_to :registration, null: false, foreign_key: true, index: { unique: true }
      t.string     :deck_name
      t.string     :ponyhead_url, null: false
      t.timestamps
    end
  end
end
