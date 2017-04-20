require_relative './discount_type_parser'

module Silpo
  class PriceOfTheWeekParser < DiscountTypeParser
    class << self
      private

      def discount_type_name
        'price_of_the_week'
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
