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

ActiveRecord::Schema[7.1].define(version: 2024_04_17_215546) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "check_ins", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_check_ins_on_created_by_id"
    t.index ["registration_id"], name: "index_check_ins_on_registration_id", unique: true
  end

  create_table "decklists", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.string "deck_name"
    t.string "ponyhead_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_decklists_on_registration_id", unique: true
  end

  create_table "event_announcement_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "discord_channel_id", null: false
    t.bigint "discord_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_announcement_configs_on_event_id", unique: true
  end

  create_table "event_check_in_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "discord_channel_id", null: false
    t.bigint "discord_message_id"
    t.string "time_zone"
    t.date "starts_at_date", null: false
    t.time "starts_at_time", null: false
    t.virtual "starts_at", type: :timestamptz, as: "timezone((time_zone)::text, (starts_at_date + starts_at_time))", stored: true
    t.date "ends_at_date"
    t.time "ends_at_time"
    t.virtual "ends_at", type: :timestamptz, as: "timezone((time_zone)::text, (ends_at_date + ends_at_time))", stored: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_check_in_configs_on_event_id", unique: true
    t.check_constraint "starts_at IS NULL OR ends_at IS NULL OR starts_at < ends_at"
  end

  create_table "event_decklist_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "visibility", null: false
    t.boolean "decklist_required", default: false, null: false
    t.string "format"
    t.string "format_behaviour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_decklist_configs_on_event_id", unique: true
  end

  create_table "event_payment_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "currency", null: false
    t.integer "price_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_payment_configs_on_event_id", unique: true
    t.check_constraint "price_cents > 0"
  end

  create_table "event_role_configs", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "discord_role_id"
    t.string "name", null: false
    t.string "permissions", default: "0", null: false
    t.integer "colour", default: 0, null: false
    t.boolean "hoist", default: false, null: false
    t.boolean "mentionable", default: false, null: false
    t.interval "cleanup_delay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_role_configs_on_event_id", unique: true
  end

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

  create_table "registrations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "player_id", null: false
    t.bigint "created_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_registrations_on_created_by_id"
    t.index ["event_id", "player_id"], name: "index_registrations_on_event_id_and_player_id", unique: true
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["player_id"], name: "index_registrations_on_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "discord_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discord_user_id"], name: "index_users_on_discord_user_id", unique: true
  end

  add_foreign_key "check_ins", "registrations"
  add_foreign_key "check_ins", "users", column: "created_by_id"
  add_foreign_key "decklists", "registrations"
  add_foreign_key "event_announcement_configs", "events"
  add_foreign_key "event_check_in_configs", "events"
  add_foreign_key "event_decklist_configs", "events"
  add_foreign_key "event_payment_configs", "events"
  add_foreign_key "event_role_configs", "events"
  add_foreign_key "events", "users", column: "created_by_id"
  add_foreign_key "registrations", "events"
  add_foreign_key "registrations", "users", column: "created_by_id"
  add_foreign_key "registrations", "users", column: "player_id"
end
