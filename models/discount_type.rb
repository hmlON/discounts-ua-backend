# Shop has many discount types
# e.g. Silpo has "price_of_the_week" and "hot_proposal"
class DiscountType < ActiveRecord::Base
  belongs_to :shop
  has_many :periods, class_name: 'DiscountTypePeriod', foreign_key: 'discount_type_id', dependent: :destroy

  def url
    shop.url + path
  end

  def active_period
    periods.find_by('end_date >= ?', Date.today)
  end
end
