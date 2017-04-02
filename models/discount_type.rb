# Shop has many discount types
# e.g. Silpo has "price_of_the_week" and "hot_proposal"
class DiscountType < ActiveRecord::Base
  belongs_to :shop
  has_many :discount_type_periods, dependent: :destroy
end
