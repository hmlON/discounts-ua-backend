# Discounts come from shop
class Shop < ActiveRecord::Base
  has_many :discount_types, dependent: :destroy
end
