require 'bundler'
Bundler.require(:default)
require 'sinatra/reloader' if development?
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./app/serializers/*.rb'].each { |file| require file }
set :serializers_path, './models/serializers'

get '/' do
  check_existance_of_shops
  check_existance_of_active_periods
  shops = Shop.includes(discount_types: { periods: :discounts }).all
  slim :index, locals: { shops: shops }
end

get '/api/shops' do
  check_existance_of_shops
  check_existance_of_active_periods
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

  shops = Shop.includes(discount_types: { periods: :discounts }).all
  serializers = shops.map { |shop| ShopSerializer.new(shop) }
  json serializers, root: 'niads'
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

def check_existance_of_shops
  Shop.create_all
end

def check_existance_of_active_periods
  Shop.all.each do |shop|
    shop.discount_types.each do |discount_type|
      unless discount_type.active_period
        shop.name.camelize.constantize
            .send(discount_type.name.to_sym)
      end
    end
  end
end

helpers do
  def format_price(price)
    format('%.2f', price)
  end
end
