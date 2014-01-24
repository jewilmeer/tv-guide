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

ActiveRecord::Schema.define(version: 20140124155357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "downloads", force: true do |t|
    t.integer  "episode_id"
    t.string   "download_type"
    t.string   "download_file_name"
    t.string   "download_content_type"
    t.integer  "download_file_size"
    t.string   "origin"
    t.string   "site"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "nr"
    t.date     "airdate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
    t.datetime "airs_at"
    t.integer  "season_nr"
    t.integer  "tvdb_id"
    t.string   "program_name"
    t.string   "thumb"
    t.integer  "sort_nr"
  end

  add_index "episodes", ["airdate"], name: "index_episodes_on_airdate", using: :btree
  add_index "episodes", ["airs_at"], name: "index_episodes_on_airs_at", using: :btree
  add_index "episodes", ["sort_nr"], name: "index_episodes_on_sort_nr", using: :btree
  add_index "episodes", ["updated_at"], name: "index_episodes_on_updated_at", using: :btree

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
  end

  create_table "genres_programs", id: false, force: true do |t|
    t.integer "genre_id"
    t.integer "program_id"
  end

  create_table "images", force: true do |t|
    t.string   "file"
    t.string   "source_url"
    t.string   "image_type"
    t.boolean  "downloaded", default: false
    t.integer  "program_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "interactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "episode_id"
    t.integer  "program_id"
    t.string   "format",           default: "nzb"
    t.string   "interaction_type"
    t.string   "end_point"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_agent"
    t.string   "referer"
  end

  create_table "networks", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "programs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_name"
    t.text     "overview"
    t.string   "status"
    t.integer  "tvdb_id"
    t.string   "imdb_id"
    t.string   "airs_dayofweek"
    t.string   "airs_time"
    t.integer  "runtime"
    t.string   "network_name"
    t.string   "contentrating"
    t.text     "actors"
    t.integer  "tvdb_rating"
    t.datetime "last_checked_at"
    t.string   "time_zone_offset",          default: "Central Time (US & Canada)"
    t.integer  "max_season_nr",             default: 1
    t.integer  "current_season_nr",         default: 1
    t.string   "tvdb_name"
    t.integer  "program_preferences_count", default: 0
    t.datetime "first_aired"
    t.string   "slug"
    t.integer  "network_id"
    t.boolean  "active",                    default: true
  end

  add_index "programs", ["slug"], name: "index_programs_on_slug", unique: true, using: :btree
  add_index "programs", ["tvdb_id"], name: "index_programs_on_tvdb_id", unique: true, using: :btree

  create_table "programs_stations", force: true do |t|
    t.integer "station_id"
    t.integer "program_id"
  end

  create_table "stations", force: true do |t|
    t.string   "name",          null: false
    t.integer  "user_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stations", ["slug"], name: "index_stations_on_slug", using: :btree
  add_index "stations", ["taggable_type"], name: "index_stations_on_taggable_type", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                null: false
    t.string   "password_salt"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_uid"
    t.boolean  "admin",                default: false
    t.boolean  "trusted",              default: false
    t.string   "login"
    t.string   "encrypted_password"
    t.string   "authentication_token"
    t.integer  "sign_in_count",        default: 0,     null: false
    t.integer  "failed_attempts",      default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_login_ip"
    t.integer  "programs_count",       default: 0
    t.integer  "interactions_count",   default: 0
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.string   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "downloads", "episodes", name: "downloads_episode_id_fk", dependent: :delete

  add_foreign_key "episodes", "programs", name: "episodes_program_id_fk", dependent: :delete

  add_foreign_key "genres_programs", "genres", name: "genres_programs_genre_id_fk"
  add_foreign_key "genres_programs", "programs", name: "genres_programs_program_id_fk"

  add_foreign_key "images", "programs", name: "images_program_id_fk", dependent: :delete

  add_foreign_key "interactions", "episodes", name: "interactions_episode_id_fk", dependent: :delete
  add_foreign_key "interactions", "programs", name: "interactions_program_id_fk", dependent: :delete
  add_foreign_key "interactions", "users", name: "interactions_user_id_fk", dependent: :delete

  add_foreign_key "programs_stations", "programs", name: "programs_stations_program_id_fk"
  add_foreign_key "programs_stations", "stations", name: "programs_stations_station_id_fk"

  add_foreign_key "stations", "users", name: "stations_user_id_fk", dependent: :delete

end
