# Every discount type has a period when certain discounts are active
class DiscountTypePeriod < ActiveRecord::Base
  belongs_to :discount_type
  has_many :discounts, dependent: :destroy
end
