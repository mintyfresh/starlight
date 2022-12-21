# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.belongs_to :section, null: false, foreign_key: true
      t.belongs_to :author, null: false, foreign_key: { to_table: :users }
      t.string     :title, null: false
      t.integer    :posts_count, null: false, default: 0
      t.integer    :views_count, null: false, default: 0
      t.timestamps
      t.timestamp  :deleted_at
      t.uuid       :deleted_in, index: true
      t.belongs_to :deleted_by, null: false, foreign_key: { to_table: :users }
    end
  end
end
