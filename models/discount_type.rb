# Shop has many discount types
class DiscountType
  attr_reader :name, :shop

  def initialize(name:, shop:)
    self.name = name
    self.shop = shop
  end

  private

  attr_writer :name, :shop
end
