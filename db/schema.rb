# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_28_154126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calls", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "scheduled_on", null: false
    t.bigint "group_id", null: false
    t.index ["group_id"], name: "index_calls_on_group_id"
    t.index ["scheduled_on"], name: "index_calls_on_scheduled_on"
  end

  create_table "group_invites", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "token", null: false
    t.boolean "accepted", default: false, null: false
    t.bigint "group_id", null: false
    t.index ["email"], name: "index_group_invites_on_email"
    t.index ["group_id"], name: "index_group_invites_on_group_id"
    t.index ["token"], name: "index_group_invites_on_token"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.bigint "creator_id", null: false
    t.index ["creator_id"], name: "index_groups_on_creator_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.string "role", default: "member", null: false
    t.index ["group_id", "user_id"], name: "index_memberships_on_group_id_and_user_id"
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "call_id", null: false
    t.string "body", null: false
    t.bigint "author_id", null: false
    t.index ["author_id"], name: "index_notes_on_author_id"
    t.index ["call_id"], name: "index_notes_on_call_id"
  end

  create_table "timers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "duration", default: 900, null: false
    t.bigint "group_id", null: false
    t.index ["group_id"], name: "index_timers_on_group_id"
    t.index ["user_id"], name: "index_timers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "role", default: "member", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
