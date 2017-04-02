SHOPS_DATA = [
  { name: 'silpo',
    discount_types: [
      { name: 'price_of_the_week' },
      { name: 'hot_proposal' }
    ] }
]

SHOPS_DATA.each do |shop_data|
  shop = Shop.create(name: shop_data[:name])
  shop_data[:discount_types].each do |discount_type_data|
    shop.discount_types.create(name: discount_type_data[:name])
  end
end
