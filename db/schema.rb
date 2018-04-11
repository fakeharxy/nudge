# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180411154258) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "completes", force: :cascade do |t|
    t.string   "body"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "tag"
    t.string   "second"
    t.index ["user_id"], name: "index_completes_on_user_id", using: :btree
  end

  create_table "note_tags", force: :cascade do |t|
    t.integer  "note_id"
    t.integer  "tag_id"
    t.boolean  "primary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_note_tags_on_note_id", using: :btree
    t.index ["tag_id"], name: "index_note_tags_on_tag_id", using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.text     "body"
    t.date     "todo_by"
    t.date     "last_seen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "seentoday"
    t.integer  "user_id"
    t.integer  "tag_id"
    t.integer  "second_id"
    t.integer  "importance"
    t.index ["second_id"], name: "index_notes_on_second_id", using: :btree
    t.index ["tag_id"], name: "index_notes_on_tag_id", using: :btree
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "seconds", force: :cascade do |t|
    t.string   "name"
    t.integer  "importance"
    t.integer  "tag_id"
    t.integer  "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["note_id"], name: "index_seconds_on_note_id", using: :btree
    t.index ["tag_id"], name: "index_seconds_on_tag_id", using: :btree
    t.index ["user_id"], name: "index_seconds_on_user_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "importance"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_tags_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.date     "last_cleanup"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "completes", "users"
  add_foreign_key "note_tags", "notes"
  add_foreign_key "note_tags", "tags"
  add_foreign_key "notes", "users"
  add_foreign_key "seconds", "users"
  add_foreign_key "tags", "users"
end
