class ShopInitializer
  attr_reader :shop_data

  def initialize(**shop_data)
    @shop_data = shop_data
  end

  def call
    shop = Shop.find_or_create_by(slug: shop_data[:slug])
    shop.name = shop_data[:name]
    shop.url = shop_data[:url]
    shop.save!
    shop
  end
end
