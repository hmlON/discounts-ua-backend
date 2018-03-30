Dir['./config/*.rb'].each { |file| require file }

Time.zone = 'Europe/Kiev'

require 'bugsnag'
Bugsnag.configure do |config|
  config.api_key = 'c5f7bcb19e53d3a0d02e8714610683c0'
end
set :raise_errors, true
use Bugsnag::Rack

require 'selenium/webdriver'
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.register_driver :headless_chrome do |app|
  chrome_binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
  chrome_binary_opts = chrome_binary ? { binary: chrome_binary } : {}

  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu] }.merge(chrome_binary_opts)
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end
Capybara.default_driver = :headless_chrome
Capybara.default_selector = :xpath

SHOP_CONFIGS = ShopConfigs.new(path_to_config: './config/shops.yml')
