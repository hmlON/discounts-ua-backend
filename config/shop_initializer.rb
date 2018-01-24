# initializes (creates or updates) shops from config
class ShopInitializer
  attr_reader :data

  def initialize(**data)
    @data = data
  end

  def call
    shop = Shop.find_or_create_by(slug: data[:slug])
    shop.name = data[:name]
    shop.url = data[:url]
    shop.save!
    shop
  end
end
