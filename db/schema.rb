# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_11_020033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "type"
    t.bigint "created_by_id", null: false
    t.bigint "discord_guild_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "location"
    t.string "description"
    t.string "time_zone"
    t.date "starts_at_date"
    t.time "starts_at_time"
    t.virtual "starts_at", type: :timestamptz, as: "timezone((time_zone)::text, (starts_at_date + starts_at_time))", stored: true
    t.date "ends_at_date"
    t.time "ends_at_time"
    t.virtual "ends_at", type: :timestamptz, as: "timezone((time_zone)::text, (ends_at_date + ends_at_time))", stored: true
    t.date "registration_starts_at_date"
    t.time "registration_starts_at_time"
    t.virtual "registration_starts_at", type: :timestamptz, as: "timezone((time_zone)::text, (registration_starts_at_date + registration_starts_at_time))", stored: true
    t.date "registration_ends_at_date"
    t.time "registration_ends_at_time"
    t.virtual "registration_ends_at", type: :timestamptz, as: "timezone((time_zone)::text, (registration_ends_at_date + registration_ends_at_time))", stored: true
    t.integer "registrations_count", default: 0, null: false
    t.integer "registrations_limit"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
    t.index ["slug"], name: "index_events_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "discord_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discord_user_id"], name: "index_users_on_discord_user_id", unique: true
  end

  add_foreign_key "events", "users", column: "created_by_id"
end
