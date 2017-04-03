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

ActiveRecord::Schema.define(version: 20170403072609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discount_type_periods", force: :cascade do |t|
    t.datetime "start_date",       null: false
    t.datetime "end_date",         null: false
    t.integer  "discount_type_id", null: false
    t.index ["discount_type_id"], name: "index_discount_type_periods_on_discount_type_id", using: :btree
  end

  create_table "discount_types", force: :cascade do |t|
    t.string  "name",    null: false
    t.integer "shop_id", null: false
    t.index ["shop_id"], name: "index_discount_types_on_shop_id", using: :btree
  end

  create_table "discounts", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "img_url",                 null: false
    t.float    "price_new",               null: false
    t.float    "price_old",               null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "discount_type_period_id", null: false
    t.index ["discount_type_period_id"], name: "index_discounts_on_discount_type_period_id", using: :btree
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
  end

  add_foreign_key "discount_type_periods", "discount_types"
  add_foreign_key "discount_types", "shops"
  add_foreign_key "discounts", "discount_type_periods"
end
