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

ActiveRecord::Schema.define(version: 20151228193733) do

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
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "name"
    t.string   "email"
    t.string   "neighborhood"
    t.integer  "number_of_conversations"
    t.binary   "needs_response"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
