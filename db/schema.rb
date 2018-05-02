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

ActiveRecord::Schema.define(version: 2018_05_02_153528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crawl_spots", force: :cascade do |t|
    t.integer "crawl_id"
    t.integer "spot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crawl_id"], name: "index_crawl_spots_on_crawl_id"
    t.index ["spot_id"], name: "index_crawl_spots_on_spot_id"
  end

  create_table "crawls", force: :cascade do |t|
    t.string "slug"
    t.string "term"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spots", force: :cascade do |t|
    t.float "rating"
    t.string "price"
    t.integer "review_count"
    t.string "name"
    t.string "url"
    t.string "image_url"
    t.string "city"
    t.string "country"
    t.string "address1"
    t.string "address2"
    t.string "address3"
    t.string "state"
    t.string "zip_code"
    t.float "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
