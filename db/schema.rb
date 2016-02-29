# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160224212103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

  create_table "conversations_tags", id: false, force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "tag_id"
  end

  add_index "conversations_tags", ["conversation_id"], name: "index_conversations_tags_on_conversation_id", using: :btree
  add_index "conversations_tags", ["tag_id"], name: "index_conversations_tags_on_tag_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "address"
    t.string   "neighborhood"
    t.string   "website"
    t.integer  "price"
    t.string   "purchase_url"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "short_blurb"
    t.boolean  "repeat_weekly"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body",            null: false
    t.boolean  "inbound"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.string   "neighborhood"
    t.string   "website"
    t.string   "phone_number"
    t.boolean  "monday_open"
    t.time     "monday_open_time"
    t.time     "monday_close_time"
    t.boolean  "tuesday_open"
    t.time     "tuesday_open_time"
    t.time     "tuesday_close_time"
    t.boolean  "wednesday_open"
    t.time     "wednesday_open_time"
    t.time     "wednesday_close_time"
    t.boolean  "thursday_open"
    t.time     "thursday_open_time"
    t.time     "thursday_close_time"
    t.boolean  "friday_open"
    t.time     "friday_open_time"
    t.time     "friday_close_time"
    t.boolean  "saturday_open"
    t.time     "saturday_open_time"
    t.time     "saturday_close_time"
    t.boolean  "sunday_open"
    t.time     "sunday_open_time"
    t.time     "sunday_close_time"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone_number",                       null: false
    t.integer  "conversations_count"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "conversations", "users"
  add_foreign_key "messages", "conversations"
end
