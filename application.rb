require 'bundler'
Bundler.require(:default)
Bundler.require(:development) if development?
require 'sinatra/reloader' if development?
require 'sidekiq/web'
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./app/serializers/*.rb'].each { |file| require file }
Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./app/services/*.rb'].each { |file| require file }
set :serializers_path, './models/serializers'

class ShopParserWorker
  # Run to start jobs
  # Shop.find_each.with_index(1) do |shop, i|
  #   ShopParserWorker.perform_in(i.minutes, shop.id)
  # end
  include Sidekiq::Worker 

  def perform(shop_id)
    shop = Shop.find(shop_id)

    PeriodicAction.not_often_than(1.day, ['parsing', shop.slug, Date.today]) do
      ShopParser.new(shop).call

      self.class.perform_at(Date.tomorrow.beginning_of_day + (shop.id.seconds * 5), shop_id)
    end
  end
end

before do
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'GET'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
end

get '/api/shops' do
  shops = Shop.all
  json shops: shops.as_json
end

get '/api/shops/:slug' do
  shop = Shop.includes(discount_types: { periods: :discounts }).find_by(slug: params[:slug])
  ShopParserWorker.perform_async(shop.id)
  if shop.discount_types.none?(&:active_period)
    json(started_parsing: true)
  else
    json ShopSerializer.new(shop)
  end
end
