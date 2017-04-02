# Discounts come from shop
class Shop
  attr_reader :name, :discount_types

  def initialize(name:)
    self.name = name
    self.discount_types = []
  end

  def self.all
    [
      self.silpo
    ]
  end

  def create_discount_type(name)
    self.discount_types << DiscountType.new(name: name, shop: self)
  end

  def self.silpo
    Shop.new(name: 'silpo').tap do |silpo|
      silpo.create_discount_type('price_of_the_week')
      silpo.create_discount_type('hot_proposal')
    end
  end

  private

  attr_writer :name, :discount_types
end
