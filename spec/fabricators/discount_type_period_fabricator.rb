Fabricator(:period, class_name: 'DiscountTypePeriod') do
  discounts(count: 10)
  start_date { Date.today - 1.day }
  end_date { Date.today + 1.day }
end
