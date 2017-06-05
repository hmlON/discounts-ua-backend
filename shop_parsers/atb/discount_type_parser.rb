module ATB
  class DiscountTypeParser < BaseDiscountTypeParser
    class << self
      def shop_name
        'ATB'
      end

      def all_discount_elements(page)
        page.css('.promo_list').reverse.drop(1).reverse
      end

      # TODO: move this options to element parser
      def common_parse_options
        {
          all_discounts_css: '.promo_list'
        }
      end

      def parse_discounts
        parse_page(discount_type.url)
      end

      def parse_dates(page)
        page.css('.ots').children[3].children[3].children[0].text
            .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
            .map { |date| Date.parse(date) }
      end
    end
  end
end
