module ATB
  class DiscountTypeParser < BaseDiscountTypeParser
    class << self
      def shop_name
        'ATB'
      end

      def all_discount_elements(page)
        page.css('.promo_list').reverse.drop(1).reverse
      end
    end
  end
end
