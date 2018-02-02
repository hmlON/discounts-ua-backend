require 'bundler'
Bundler.require(:default)
require 'sinatra/reloader' if development?
require 'capybara/poltergeist'
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./app/serializers/*.rb'].each { |file| require file }
set :serializers_path, './models/serializers'

get '/api/shops' do
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

  shops = Shop.includes(discount_types: { periods: :discounts }).all
  serializers = shops.map { |shop| ShopSerializer.new(shop) }
  Thread.new { parse_discounts }
  json shops: serializers
end

def parse_discounts
  SHOP_CONFIGS.each do |shop_slug, shop_data|
    shop = Shop.find_by(slug: shop_slug)
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
