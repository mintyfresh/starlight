# frozen_string_literal: true

class CreateUserCredentials < ActiveRecord::Migration[7.0]
  def change
    create_table :user_credentials do |t|
      t.string     :type, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.string     :external_id
      t.jsonb      :secret_data
      t.timestamp  :expires_at
      t.timestamps

      t.index %i[type external_id], unique: true
      t.index %i[type user_id], unique: true
    end
  end
end
