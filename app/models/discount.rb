# Schema
# t.string   "name",                    null: false
# t.string   "img_url",                 null: false
# t.string   "small_img_url"
# t.float    "price_new",               null: false
# t.float    "price_old",               null: false
# t.datetime "created_at",              null: false
# t.datetime "updated_at",              null: false
# t.integer  "discount_type_period_id", null: false
class Discount < ActiveRecord::Base
  belongs_to :discount_type_period

  default_scope { order(:id) }
end
