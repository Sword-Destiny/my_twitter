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

ActiveRecord::Schema.define(version: 20171218045518) do

  create_table "comment_thumbs_ups", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "tweet_id"
    t.string   "contents"
    t.integer  "user_id"
    t.integer  "thumbs_up_num"
    t.integer  "replyed_num"
    t.integer  "reply_comment_id"
    t.integer  "top_comment_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "im_infos", force: :cascade do |t|
    t.integer  "from"
    t.integer  "to"
    t.string   "info"
    t.integer  "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweet_tags", force: :cascade do |t|
    t.integer  "tweet_id"
    t.string   "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweet_thumbs_ups", force: :cascade do |t|
    t.integer  "tweet_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "contents"
    t.integer  "comment_num"
    t.integer  "thumbs_up_num"
    t.integer  "transmit_num"
    t.string   "transmit_from_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "user_tags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.integer  "unread_info_num"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "head_picture"
  end

end
