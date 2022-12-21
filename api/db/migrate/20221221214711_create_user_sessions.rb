# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_sessions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.binary     :creation_ip_ciphertext
      t.binary     :creation_ip_bidx, index: true
      t.binary     :current_ip_ciphertext
      t.binary     :current_ip_bidx, index: true
      t.timestamp  :expires_at, null: false
      t.timestamp  :revoked_at
      t.timestamps
    end
  end
end
