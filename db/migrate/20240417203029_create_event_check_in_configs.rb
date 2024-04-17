# frozen_string_literal: true

class CreateEventCheckInConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :event_check_in_configs do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.string     :time_zone
      t.date       :starts_at_date, null: false
      t.time       :starts_at_time, null: false
      t.virtual    :starts_at, type: :timestamptz, stored: true, as: <<-SQL.squish
        (starts_at_date + starts_at_time) AT TIME ZONE time_zone
      SQL
      t.date       :ends_at_date
      t.time       :ends_at_time
      t.virtual    :ends_at, type: :timestamptz, stored: true, as: <<-SQL.squish
        (ends_at_date + ends_at_time) AT TIME ZONE time_zone
      SQL
      t.timestamps

      t.check_constraint <<-SQL.squish
        starts_at IS NULL OR ends_at IS NULL OR starts_at < ends_at
      SQL
    end
  end
end
