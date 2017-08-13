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

      def parse_dates(_page)
        start_date = Date.today.beginning_of_week(:thursday)
        end_date = start_date + 6.days
        start_date..end_date
      end
    end
  end
end
