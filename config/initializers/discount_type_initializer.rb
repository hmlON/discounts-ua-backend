# initializes (creates or updates) discount types from config
class DiscountTypeInitializer
  attr_reader :shop, :data

  def initialize(shop:, **data)
    @shop = shop
    @data = data
  end

  def call
    discount_type = shop.discount_types.find_or_initialize_by(slug: data[:slug])
    discount_type.name = data[:name]
    discount_type.periodic = data[:period].present?
    discount_type.save
  end
end
