Dir['./config/*.rb'].each { |file| require file }

Time.zone = 'Europe/Kiev'

SHOP_CONFIGS = YAML.load(File.open './config/shops.yml').deep_symbolize_keys.freeze


SHOP_CONFIGS.each do |shop_slug, shop_data|
  shop = ShopInitializer.new(shop_data.merge(slug: shop_slug)).call

  require "byebug"; byebug

  shop_data[:discount_types].each do |discount_type_slug, discount_type_data|
    discount_type = shop.discount_types.find_or_create_by(slug: discount_type_slug)
    discount_type.name = discount_type_data[:name]
    discount_type.path = discount_type_data[:path]
    discount_type.save
  end
end
