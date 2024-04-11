# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string     :type
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.bigint     :discord_guild_id, null: false
      t.string     :name, null: false
      t.string     :slug, null: false, index: { unique: true }
      t.string     :location
      t.string     :description
      t.string     :time_zone
      t.date       :starts_at_date
      t.time       :starts_at_time
      t.virtual    :starts_at, type: :timestamptz, stored: true, as: <<-SQL.squish
        (starts_at_date + starts_at_time) AT TIME ZONE time_zone
      SQL
      t.date       :ends_at_date
      t.time       :ends_at_time
      t.virtual    :ends_at, type: :timestamptz, stored: true, as: <<-SQL.squish
        (ends_at_date + ends_at_time) AT TIME ZONE time_zone
      SQL
      t.date       :registration_starts_at_date
      t.time       :registration_starts_at_time
      t.virtual    :registration_starts_at, type: :timestamptz, stored: true, as: <<-SQL.squish
        (registration_starts_at_date + registration_starts_at_time) AT TIME ZONE time_zone
      SQL
      t.date       :registration_ends_at_date
      t.time       :registration_ends_at_time
      t.virtual    :registration_ends_at, type: :timestamptz, stored: true, as: <<-SQL.squish
        (registration_ends_at_date + registration_ends_at_time) AT TIME ZONE time_zone
      SQL
      t.integer    :registrations_count, null: false, default: 0
      t.integer    :registrations_limit
      t.timestamp  :published_at
      t.timestamps
    end
  end
end
