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

ActiveRecord::Schema.define(version: 20150105070106) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", force: true do |t|
    t.string   "title"
    t.string   "youtube_id"
    t.string   "channel_image_url"
    t.string   "category"
    t.integer  "subscriber_count"
    t.integer  "videos_count"
    t.datetime "joinned_on"
    t.string   "latest_video_title"
    t.string   "latest_video_link"
    t.string   "latest_video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "query_id"
    t.datetime "latest_video_published_at"
    t.text     "description"
    t.string   "country"
    t.integer  "view_count",                limit: 8
  end

  create_table "countaries", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queries", force: true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "country"
    t.integer  "min_subscriber_count"
    t.integer  "max_subscriber_count"
    t.string   "min_total_views"
    t.string   "max_total_views"
    t.integer  "min_total_videos"
    t.datetime "last_video_published"
    t.string   "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
