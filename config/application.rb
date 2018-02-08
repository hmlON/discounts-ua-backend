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

SHOP_CONFIGS = ShopConfigs.new(path_to_config: './config/shops.yml')

SHOP_CONFIGS.initialize_shops
