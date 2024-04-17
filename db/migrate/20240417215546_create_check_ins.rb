# frozen_string_literal: true

class CreateCheckIns < ActiveRecord::Migration[7.1]
  def change
    create_table :check_ins do |t|
      t.belongs_to :registration, null: false, foreign_key: true, index: { unique: true }
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
