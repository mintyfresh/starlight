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

ActiveRecord::Schema[7.0].define(version: 2022_12_21_214711) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.bigint "author_id", null: false
    t.bigint "last_editor_id"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", precision: nil
    t.uuid "deleted_in"
    t.bigint "deleted_by_id"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["deleted_by_id"], name: "index_posts_on_deleted_by_id"
    t.index ["deleted_in"], name: "index_posts_on_deleted_in"
    t.index ["last_editor_id"], name: "index_posts_on_last_editor_id"
    t.index ["topic_id"], name: "index_posts_on_topic_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.bigint "author_id", null: false
    t.string "title", null: false
    t.integer "posts_count", default: 0, null: false
    t.integer "views_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at", precision: nil
    t.uuid "deleted_in"
    t.bigint "deleted_by_id"
    t.index ["author_id"], name: "index_topics_on_author_id"
    t.index ["deleted_by_id"], name: "index_topics_on_deleted_by_id"
    t.index ["deleted_in"], name: "index_topics_on_deleted_in"
    t.index ["section_id"], name: "index_topics_on_section_id"
  end

  create_table "user_credentials", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "user_id", null: false
    t.string "external_id"
    t.jsonb "secret_data"
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type", "external_id"], name: "index_user_credentials_on_type_and_external_id", unique: true
    t.index ["type", "user_id"], name: "index_user_credentials_on_type_and_user_id", unique: true
    t.index ["user_id"], name: "index_user_credentials_on_user_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.binary "creation_ip_ciphertext"
    t.binary "creation_ip_bidx"
    t.binary "current_ip_ciphertext"
    t.binary "current_ip_bidx"
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creation_ip_bidx"], name: "index_user_sessions_on_creation_ip_bidx"
    t.index ["current_ip_bidx"], name: "index_user_sessions_on_current_ip_bidx"
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.binary "email_ciphertext", null: false
    t.binary "email_bidx", null: false
    t.citext "display_name", null: false
    t.integer "posts_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_name"], name: "index_users_on_display_name", unique: true
    t.index ["email_bidx"], name: "index_users_on_email_bidx", unique: true
  end

  add_foreign_key "posts", "topics"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "posts", "users", column: "deleted_by_id", on_delete: :nullify
  add_foreign_key "posts", "users", column: "last_editor_id", on_delete: :nullify
  add_foreign_key "topics", "sections"
  add_foreign_key "topics", "users", column: "author_id"
  add_foreign_key "topics", "users", column: "deleted_by_id", on_delete: :nullify
  add_foreign_key "user_credentials", "users"
  add_foreign_key "user_sessions", "users"
end
