Fabricator(:shop) do
  discount_types(count: 4)
  name { Faker::Company.name }
  slug { |attrs| attrs[:name].parameterize }
end
