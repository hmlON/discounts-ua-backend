require 'bundler'
Bundler.require(:default)
require 'sinatra/reloader' if development?
require 'capybara/poltergeist'
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./app/serializers/*.rb'].each { |file| require file }
set :serializers_path, './models/serializers'

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

get '/' do
  check_existance_of_shops
  check_existance_of_active_periods
  shops = Shop.includes(discount_types: { periods: :discounts }).all
  slim :index, locals: { shops: shops }
end

get '/api/shops' do
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

  shops = Shop.includes(discount_types: { periods: :discounts }).all
  serializers = shops.map { |shop| ShopSerializer.new(shop) }
  json shops: serializers
end

get '/image-proxy/' do
  headers['Content-Type'] = 'image/jpeg'
  headers['Cache-Control'] = 'public'
  headers['Expires'] = Date.today + 1.year
  open(Base64.urlsafe_decode64 params[:url]).read
end

def image_proxy_url(url)
  "/image-proxy/?url=#{Base64.urlsafe_encode64 url}"
end

helpers do
  def format_price(price)
    format('%.2f', price)
  end
end
