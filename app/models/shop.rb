# Discounts come from shop
#
# Schema:
# t.string "slug"
# t.string "name", null: false
# t.string "url"
#
class Shop < ActiveRecord::Base
  has_many :discount_types, dependent: :destroy

  validates :slug, presence: true
  validates :name, presence: true
end
