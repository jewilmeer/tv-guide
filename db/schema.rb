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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110405165548) do

  create_table "admins", :force => true do |t|
    t.string   "email",                                            :null => false
    t.string   "encrypted_password", :limit => 128,                :null => false
    t.string   "password_salt",                                    :null => false
    t.integer  "sign_in_count",                     :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                   :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", :force => true do |t|
    t.integer  "program_id"
    t.boolean  "active",      :default => true
    t.text     "filter_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downloads", :force => true do |t|
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

  create_table "episodes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "path"
    t.integer  "nr"
    t.date     "airdate"
    t.boolean  "downloaded",       :default => false
    t.boolean  "watched",          :default => false
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nzb_file_name"
    t.string   "nzb_content_type"
    t.integer  "nzb_file_size"
    t.datetime "nzb_updated_at"
    t.integer  "program_id"
    t.datetime "airs_at"
    t.integer  "downloads",        :default => 0
    t.integer  "season_nr"
    t.integer  "tvdb_id"
    t.string   "program_name"
    t.integer  "tvdb_program_id"
  end

  add_index "episodes", ["season_id", "nr"], :name => "chained_index"

  create_table "episodes_users", :id => false, :force => true do |t|
    t.integer "episode_id"
    t.integer "user_id"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_programs", :id => false, :force => true do |t|
    t.integer "genre_id"
    t.integer "program_id"
  end

  create_table "images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "image_type"
    t.boolean  "downloaded",         :default => false
  end

  create_table "images_programs", :id => false, :force => true do |t|
    t.integer "image_id"
    t.integer "program_id"
  end

  add_index "images_programs", ["program_id", "image_id"], :name => "index_images_programs_on_program_id_and_image_id"

  create_table "interactions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "episode_id"
    t.integer  "program_id"
    t.string   "format",           :default => "nzb"
    t.string   "interaction_type"
    t.string   "end_point"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "program_updates", :force => true do |t|
    t.integer  "program_id"
    t.text     "revision_data"
    t.text     "parsed_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_name"
    t.text     "overview"
    t.string   "status"
    t.integer  "tvdb_id"
    t.datetime "tvdb_last_update"
    t.string   "imdb_id"
    t.string   "airs_dayofweek"
    t.string   "airs_time"
    t.integer  "runtime"
    t.string   "network"
    t.string   "contentrating"
    t.text     "actors"
    t.integer  "tvdb_rating"
    t.datetime "last_checked_at"
    t.string   "time_zone_offset",  :default => "Central Time (US & Canada)"
    t.integer  "max_season_nr",     :default => 1
    t.integer  "current_season_nr", :default => 1
    t.string   "tvdb_name"
    t.integer  "fanart_image_id"
    t.integer  "poster_image_id"
    t.integer  "season_image_id"
    t.integer  "series_image_id"
  end

  create_table "programs_users", :id => false, :force => true do |t|
    t.integer "program_id"
    t.integer "user_id"
  end

  add_index "programs_users", ["program_id", "user_id"], :name => "index_programs_users_on_program_id_and_user_id"
  add_index "programs_users", ["user_id", "program_id"], :name => "index_programs_users_on_user_id_and_program_id"

  create_table "seasons", :force => true do |t|
    t.integer  "nr"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "password_salt",                          :null => false
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "oauth_uid"
    t.boolean  "admin",               :default => false
    t.boolean  "trusted",             :default => false
    t.string   "login"
    t.string   "crypted_password"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
