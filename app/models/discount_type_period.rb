# Every discount type has a period when certain discounts are active
#
# Schema:
# t.datetime "start_date", null: false
# t.datetime "end_date", null: false
# t.integer "discount_type_id", null: false
#
class DiscountTypePeriod < ActiveRecord::Base
  belongs_to :discount_type
  has_many :discounts, dependent: :destroy
end
