class ShopParserWorker
  include Sidekiq::Worker

  def perform(shop_id)
    shop = Shop.find(shop_id)

    PeriodicAction.not_often_than(1.hour, ['parsing', shop.slug, Date.today]) do
      ShopParser.new(shop).call
    end
  end
end
