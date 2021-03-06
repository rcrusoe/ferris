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

ActiveRecord::Schema.define(version: 20160404171637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blacklist", force: :cascade do |t|
    t.string   "fb_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "keywords"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "messages_count"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.date     "pref_begin_time"
    t.date     "pref_end_time"
    t.text     "pref_location"
    t.text     "pref_categories"
    t.boolean  "needs_human",     default: false
    t.integer  "state",           default: 0,     null: false
  end

  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "website"
    t.integer  "price"
    t.string   "purchase_url"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "short_blurb"
    t.integer  "place_id"
    t.text     "recurrence"
    t.string   "fb_id"
    t.boolean  "approved",           default: true
    t.integer  "attending_count"
    t.integer  "maybe_count"
    t.integer  "interested_count"
    t.integer  "category_id"
  end

  add_index "events", ["category_id"], name: "index_events_on_category_id", using: :btree
  add_index "events", ["place_id"], name: "index_events_on_place_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "body",            null: false
    t.boolean  "inbound"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree

  create_table "occurrences", force: :cascade do |t|
    t.integer  "event_id"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "occurrences", ["event_id"], name: "index_occurrences_on_event_id", using: :btree

  create_table "open_times", force: :cascade do |t|
    t.integer  "place_id"
    t.integer  "day"
    t.time     "open_time"
    t.time     "close_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "open_times", ["place_id"], name: "index_open_times_on_place_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "neighborhood"
    t.string   "website"
    t.string   "phone_number"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "fb_id"
    t.integer  "fb_likes"
    t.integer  "fb_checkins"
    t.boolean  "approved",           default: true
    t.string   "email"
    t.text     "fb_link"
    t.string   "price_range"
    t.text     "about"
    t.float    "lat"
    t.float    "lng"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
  end

  create_table "places_tags", id: false, force: :cascade do |t|
    t.integer "place_id", null: false
    t.integer "tag_id",   null: false
  end

  add_index "places_tags", ["place_id", "tag_id"], name: "index_places_tags_on_place_id_and_tag_id", using: :btree
  add_index "places_tags", ["tag_id", "place_id"], name: "index_places_tags_on_tag_id_and_place_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone_number",                          null: false
    t.integer  "conversations_count"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "name"
    t.boolean  "local",                  default: true, null: false
  end

  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "conversations", "users"
  add_foreign_key "events", "categories"
  add_foreign_key "events", "places"
  add_foreign_key "messages", "conversations"
  add_foreign_key "occurrences", "events"
  add_foreign_key "open_times", "places"
end
