# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.belongs_to :topic, null: false, foreign_key: true
      t.belongs_to :author, null: false, foreign_key: { to_table: :users }
      t.belongs_to :last_editor, null: true, foreign_key: { to_table: :users, on_delete: :nullify }
      t.string     :body
      t.timestamps
      t.timestamp  :deleted_at
      t.uuid       :deleted_in, index: true
      t.belongs_to :deleted_by, null: true, foreign_key: { to_table: :users, on_delete: :nullify }
    end
  end
end
