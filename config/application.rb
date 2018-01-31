Dir['./config/*.rb'].each { |file| require file }

Time.zone = 'Europe/Kiev'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    js_errors: false,
    phantomjs_options: ['--load-images=false']
  )
end
Capybara.default_driver = :poltergeist
Capybara.default_selector = :xpath

SHOP_CONFIGS = YAML.load(File.open './config/shops.yml').deep_symbolize_keys.freeze

SHOP_CONFIGS.each do |shop_slug, shop_data|
  shop = ShopInitializer.new(slug: shop_slug, **shop_data).call

  shop_data[:discount_types].each do |discount_type_slug, discount_type_data|
    DiscountTypeInitializer.new(shop: shop, slug: discount_type_slug, **discount_type_data).call
  end
end
