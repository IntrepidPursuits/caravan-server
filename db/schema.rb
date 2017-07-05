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

ActiveRecord::Schema.define(version: 20170705153335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "cars", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "trip_id", null: false
    t.integer "max_seats", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["name", "trip_id"], name: "index_cars_on_name_and_trip_id", unique: true
    t.index ["trip_id"], name: "index_cars_on_trip_id"
  end

  create_table "google_identities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.text "image"
    t.string "provider", default: "google", null: false
    t.string "uid", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_google_identities_on_email", unique: true
    t.index ["uid"], name: "index_google_identities_on_uid", unique: true
    t.index ["user_id"], name: "index_google_identities_on_user_id", unique: true
  end

  create_table "invite_codes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.index ["code"], name: "index_invite_codes_on_code", unique: true
  end

  create_table "locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "car_id", null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_locations_on_car_id"
  end

  create_table "signups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "trip_id", null: false
    t.uuid "user_id", null: false
    t.uuid "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id", "trip_id"], name: "index_signups_on_car_id_and_trip_id", unique: true
    t.index ["car_id"], name: "index_signups_on_car_id"
    t.index ["trip_id", "user_id"], name: "index_signups_on_trip_id_and_user_id", unique: true
  end

  create_table "trips", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "creator_id", null: false
    t.string "name", null: false
    t.datetime "departing_on", null: false
    t.string "destination_address", null: false
    t.decimal "destination_latitude", null: false
    t.decimal "destination_longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "invite_code_id", null: false
    t.index ["creator_id"], name: "index_trips_on_creator_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
