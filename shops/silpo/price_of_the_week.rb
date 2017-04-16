module Silpo
  class PriceOfTheWeek < DiscountTypeParser
    class << self
      def parse_discounts
        page = Nokogiri::HTML(open(shop.base_url + discount_type.url))
        dates = parse_dates(page)

        active_discount_type = discount_type.periods.find_or_create_by(start_date: dates.min, end_date: dates.max)
        parse_discount_type(active_discount_type)
      end

      private

      def discount_type
        shop.discount_types.find_or_create_by(name: 'price_of_the_week', url: '/ru/actions/priceoftheweek')
      end

      def parse_options
        {
          price_new_css: { hrn: '.price_2014_new .hrn',
                           kop: '.price_2014_new .kop' },
          price_old_css: { hrn: '.price_2014_old .hrn',
                           kop: '.price_2014_old .kop' }
        }
      end

      # TODO: change to use ranges
      def parse_dates(page)
        page.css('.ots').children[3].children[3].children[0].text
            .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
            .map { |date| Date.parse(date) }
      end
    end
  end
end
