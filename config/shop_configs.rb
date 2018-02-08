class ShopConfigs
  include Enumerable

  def initialize(path_to_config:)
    @shop_configs = YAML.load(File.open path_to_config).deep_symbolize_keys
  end

  def each
    shop_configs.each { |config| yield config }
  end

  def initialize_shops
    each do |shop_slug, shop_data|
      shop = ShopInitializer.new(slug: shop_slug, **shop_data).call

      shop_data[:discount_types].each do |discount_type_slug, discount_type_data|
        DiscountTypeInitializer.new(shop: shop, slug: discount_type_slug, **discount_type_data).call
      end
    end
  end

  private

  attr_reader :shop_configs
end
