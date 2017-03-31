# Discounts come from shop
class Shop
  attr_reader :name

  def initialize(name:)
    self.name = name
  end

  def self.all
    [Shop.new(name: 'silpo')]
  end

  private

  attr_writer :name
end
