# Discounts come from shop
class Shop
  attr_reader :name, :discount_types

  def initialize(name:, discount_types:)
    self.name = name
    self.discount_types = discount_types
  end

  def self.all
    [
      Shop.new(name: 'silpo',
               discount_types: [
                 DiscountType.new(name: 'price_of_the_week'),
                 DiscountType.new(name: 'hot_proposal')
               ])
    ]
  end

  private

  attr_writer :name, :discount_types
end
