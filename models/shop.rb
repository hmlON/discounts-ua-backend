# Discounts come from shop
class Shop < ActiveRecord::Base
  has_many :discount_types, dependent: :destroy

  SHOPS_DATA = [
  { name: 'silpo',
    base_url: 'http://silpo.ua',
    discount_types: [
      { name: 'price_of_the_week', url: '/ru/actions/priceoftheweek' },
      { name: 'hot_proposal', url: '/ru/actions/hotproposal' }
    ] }
  ]

  def self.create_all
    SHOPS_DATA.each do |shop_data|
      shop = Shop.find_or_create_by(name: shop_data[:name], base_url: shop_data[:base_url])
      shop_data[:discount_types].each do |discount_type_data|
        shop.discount_types.find_or_create_by(name: discount_type_data[:name], url: discount_type_data[:url])
      end
    end
    all
  end
end
