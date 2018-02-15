Dir['./config/*.rb'].each { |file| require file }

Time.zone = 'Europe/Kiev'

require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.default_driver = :chrome
Capybara.default_selector = :xpath

SHOP_CONFIGS = ShopConfigs.new(path_to_config: './config/shops.yml')

SHOP_CONFIGS.initialize_shops
