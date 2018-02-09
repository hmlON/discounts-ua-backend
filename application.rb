require 'bundler'
Bundler.require(:default)
require 'sinatra/reloader' if development?
require 'capybara/poltergeist'
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./app/serializers/*.rb'].each { |file| require file }
set :serializers_path, './models/serializers'

before do
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
end

get '/api/shops' do
  shops = Shop.includes(discount_types: { periods: :discounts }).all
  json shops: shops.as_json
end

get '/api/shops/:slug' do
  shop = Shop.includes(discount_types: { periods: :discounts }).find_by(slug: params[:slug])
  Thread.new { ShopParser.new(shop).call }
  json ShopSerializer.new(shop)
end
