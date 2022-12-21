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

ActiveRecord::Schema[7.0].define(version: 2022_12_21_194340) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "user_credentials", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "user_id", null: false
    t.string "external_id"
    t.jsonb "data"
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type", "external_id"], name: "index_user_credentials_on_type_and_external_id", unique: true
    t.index ["type", "user_id"], name: "index_user_credentials_on_type_and_user_id", unique: true
    t.index ["user_id"], name: "index_user_credentials_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.binary "email_ciphertext", null: false
    t.binary "email_bidx", null: false
    t.citext "display_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_name"], name: "index_users_on_display_name", unique: true
    t.index ["email_bidx"], name: "index_users_on_email_bidx", unique: true
  end

  add_foreign_key "user_credentials", "users"
end
