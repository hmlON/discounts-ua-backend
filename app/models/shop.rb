# Discounts come from shop
#
# Schema:
# t.string "name", null: false
# t.string "url"
#
class Shop < ActiveRecord::Base
  has_many :discount_types, dependent: :destroy



  # SHOPS_DATA = [
  #   { name: 'silpo',
  #     url: 'http://silpo.ua',
  #     discount_types: [
  #       { name: 'price_of_the_week', path: '/offers/cina-tizhnya' },
  #       { name: 'hot_proposal', path: '/offers/garyacha-propoziciya' }
  #     ] },
  #   { name: 'ATB',
  #     url: 'http://www.atbmarket.com/',
  #     discount_types: [
  #       { name: 'economy', path: '/ru/hot/akcii/economy' }
  #     ] }
  # ]

  def self.create_all
    # SHOPS_DATA.each do |shop_data|
    #   shop = Shop.find_or_create_by(name: shop_data[:name], url: shop_data[:url])
    #   shop_data[:discount_types].each do |discount_type_data|
    #     shop.discount_types.find_or_create_by(name: discount_type_data[:name], path: discount_type_data[:path])
    #   end
    # end
    # all
  end
end
