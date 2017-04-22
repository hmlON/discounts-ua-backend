require 'bundler'
Bundler.require(:default)
require 'sinatra/reloader' if development?
Dir['./models/*.rb'].each { |file| require file }
Dir['./shop_parsers/*.rb'].each { |file| require file }
Dir['./shop_parsers/**/*.rb'].each { |file| require file }

Time.zone = 'Europe/Kiev'

get '/' do
  check_existance_of_shops
  check_existance_of_active_periods
  shops = Shop.includes(discount_types: { periods: :discounts }).all
  slim :index, locals: { shops: shops }
end

get '/image-proxy/' do
    headers['Content-Type'] = 'image/jpeg'
    headers['Cache-Control'] = 'public'
    headers['Expires'] = Date.today + 1.year
    open(params[:url]).read
end

def image_proxy_url(url)
  "/image-proxy/?url=#{url}"
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
