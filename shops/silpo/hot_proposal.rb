module Silpo
  class HotProposal < DiscountTypeParser
    class << self
      def parse_discounts
        discount_type = shop.discount_types.find_or_create_by(name: 'hot_proposal', url: '/ru/actions/hotproposal')

        page = Nokogiri::HTML(open(shop.base_url + discount_type.url))
        dates = parse_dates(page)

        active_discount_type = discount_type.periods.create(start_date: dates.min, end_date: dates.max)
        parse_discount_type(active_discount_type)
      end

      private

      def parse_options
        {
          price_new_css: { hrn: '.price-hot-new .hrn',
                           kop: '.price-hot-new .kop' },
          price_old_css: { hrn: '.price-hot-old .hrn',
                           kop: '.price-hot-old .kop' }
        }
      end

      # TODO: change to use ranges
      def parse_dates(page)
        page.css('.ots').children[1].children[1].text
            .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
            .map { |date| Date.parse(date) }
      end
    end
  end
end
