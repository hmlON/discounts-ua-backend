class ShopParser
  attr_reader :shop

  def initialize(shop)
    @shop = shop
  end

  def call
    puts "parsing #{shop.name}"
    shop_data = SHOP_CONFIGS.find_shop_data(shop)

    shop_data[:discount_types].each do |discount_type_slug, discount_type_data|
      discount_type = shop.discount_types.find_by(slug: discount_type_slug)
      parser = DiscountTypeParser.new(discount_type_data)
      DiscountsCreator.new(
        discount_type: discount_type,
        discount_type_parser: parser,
        period: discount_type_data[:period]
      ).call
    end
  end
end
