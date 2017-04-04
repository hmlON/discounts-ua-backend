SHOPS_DATA = [
  { name: 'silpo',
    base_url: 'http://silpo.ua',
    discount_types: [
      { name: 'price_of_the_week', url: '/ru/actions/priceoftheweek' },
      { name: 'hot_proposal', url: '/ru/actions/hotproposal' }
    ] }
]

SHOPS_DATA.each do |shop_data|
  shop = Shop.create(name: shop_data[:name], base_url: shop_data[:base_url])
  shop_data[:discount_types].each do |discount_type_data|
    shop.discount_types.create(name: discount_type_data[:name], url: discount_type_data[:url])
  end
end
