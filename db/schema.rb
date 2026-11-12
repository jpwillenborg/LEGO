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

ActiveRecord::Schema[7.1].define(version: 2026_11_10_161945) do
  create_table "inventory_parts", force: :cascade do |t|
    t.integer "lego_set_id", null: false
    t.integer "part_id", null: false
    t.integer "quantity"
    t.integer "loose_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lego_set_id", "id"], name: "index_inventory_parts_on_lego_set_id_and_id", unique: true
    t.index ["lego_set_id"], name: "index_inventory_parts_on_lego_set_id"
    t.index ["part_id"], name: "index_inventory_parts_on_part_id"
  end

  create_table "lego_sets", force: :cascade do |t|
    t.string "set_num"
    t.string "name"
    t.integer "year"
    t.integer "total_parts"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["set_num"], name: "index_lego_sets_on_set_num", unique: true
  end

  create_table "parts", force: :cascade do |t|
    t.string "part_num"
    t.string "name"
    t.string "category"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_num"], name: "index_parts_on_part_num", unique: true
  end

  add_foreign_key "inventory_parts", "lego_sets"
  add_foreign_key "inventory_parts", "parts"
end
