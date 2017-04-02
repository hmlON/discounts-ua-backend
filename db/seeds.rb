SHOPS = [
  { name: 'silpo' }
]

SHOPS.each do |shop|
  Shop.create(name: shop[:name])
end
