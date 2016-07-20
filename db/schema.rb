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

ActiveRecord::Schema.define(version: 20160720070004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ai_players", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "game_id"
    t.integer  "cash",       default: 1000
    t.integer  "total_bet",  default: 0
  end

  create_table "cards", force: :cascade do |t|
    t.string  "value"
    t.string  "suit"
    t.string  "image"
    t.integer "game_id"
    t.integer "ai_player_id"
    t.integer "user_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "ordered_players", default: [],                 array: true
    t.integer  "pot",             default: 0
    t.integer  "little_blind",    default: 50
    t.integer  "big_blind",       default: 100
    t.boolean  "started",         default: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "password_digest"
    t.string   "email"
    t.integer  "game_id"
    t.integer  "total_bet",       default: 0
    t.integer  "cash",            default: 2000
  end

end
