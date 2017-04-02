# Shop has many discount types
# e.g. Silpo has "price_of_the_week" and "hot_proposal"
class DiscountType < ActiveRecord::Base
  belongs_to :shop
end
