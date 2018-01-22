Fabricator(:discount_type) do
  periods(count: 1)
  name { Faker::Commerce.department }
  slug { |attrs| attrs[:name].parameterize }
end
