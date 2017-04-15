module Silpo
  class PriceOfTheWeek < DiscountTypeParser
    def self.parse_discounts
      discount_type = shop.discount_types.find_or_create_by(name: 'price_of_the_week', url: '/ru/actions/priceoftheweek')

      page = Nokogiri::HTML(open(shop.base_url + discount_type.url))
      dates = page.css('.ots').children[3].children[3].children[0].text
                  .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
                  .map { |date| Date.parse(date) }

      active_discount_type = discount_type.periods.create(start_date: dates.min, end_date: dates.max)
      parse_discount_type(active_discount_type)
    end
  end
end
