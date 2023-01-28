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

ActiveRecord::Schema[7.0].define(version: 2023_01_28_161021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nodes", force: :cascade do |t|
    t.string "ip_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_nodes_on_ip_address", unique: true
  end

  create_table "statistics", force: :cascade do |t|
    t.float "average_rtt"
    t.float "minimum_rtt"
    t.float "maximum_rtt"
    t.float "median_rtt"
    t.float "standard_deviation"
    t.float "percentage_lost"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "nodes_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nodes_id"], name: "index_statistics_on_nodes_id"
  end

  add_foreign_key "statistics", "nodes", column: "nodes_id"
end
