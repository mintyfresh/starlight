# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'citext'

    create_table :users do |t|
      t.binary  :email_ciphertext, null: false
      t.binary  :email_bidx, null: false, index: { unique: true }
      t.citext  :display_name, null: false, index: { unique: true }
      t.integer :posts_count, null: false, default: 0
      t.timestamps
    end
  end
end
