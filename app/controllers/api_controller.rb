class ApiController < Sinatra::Base
  before do
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  get '/shops' do
    shops = Shop.all
    json shops: shops.as_json
  end

  get '/shops/:slug' do
    shop = Shop.includes(discount_types: { periods: :discounts }).find_by(slug: params[:slug])
    ShopParserWorker.perform_async(shop.id)
    if shop.discount_types.none?(&:active_period)
      json(started_parsing: true)
    else
      json ShopSerializer.new(shop)
    end
  end
end
