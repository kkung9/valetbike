# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_02_124500) do

  create_table "bikes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "identifier"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "docks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "bike_id"
    t.bigint "station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identifier"
    t.index ["station_id"], name: "index_docks_on_station_id"
  end

  create_table "rentals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "predicted_end_time"
    t.datetime "actual_end_time"
    t.float "predicted_fee"
    t.float "actual_fee"
    t.integer "start_station"
    t.integer "end_station"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "bike_id", null: false
    t.boolean "is_complete"
    t.index ["bike_id"], name: "index_rentals_on_bike_id"
    t.index ["user_id"], name: "index_rentals_on_user_id"
  end

  create_table "stations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "identifier"
    t.string "name"
    t.string "address"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.string "description"
    t.float "lat"
    t.float "long"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identifier"
  end

  add_foreign_key "docks", "stations"
  add_foreign_key "rentals", "bikes"
  add_foreign_key "rentals", "users"
end
