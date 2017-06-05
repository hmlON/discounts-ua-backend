require_relative './discount_type_parser'

module Silpo
  class HotProposalParser < DiscountTypeParser
    class << self
      private

      def discount_type_name
        'hot_proposal'
      end

      def parse_options
        {
          price_new_css: { hrn: '.price-hot-new .hrn',
                           kop: '.price-hot-new .kop' },
          price_old_css: { hrn: '.price-hot-old .hrn',
                           kop: '.price-hot-old .kop' }
        }
      end

      def parse_dates(page)
        dates = page.css('.ots').children[1].children[1].text
                    .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
                    .map { |date| Date.parse(date) }
        dates.min..dates.max
      end
    end
  end
end
