# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.string  :title, null: false
      t.string  :description
      t.integer :position, null: false
      t.timestamps
    end
  end
end
