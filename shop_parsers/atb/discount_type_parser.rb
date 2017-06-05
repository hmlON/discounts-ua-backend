module ATB
  class DiscountTypeParser < BaseDiscountTypeParser
    class << self
      def shop_name
        'ATB'
      end

      def all_discount_elements(page)
        page.css('.promo_list').reverse.drop(1).reverse
      end

      def parse_discounts
        parse_page(discount_type.url)
      end
    end
  end
end
