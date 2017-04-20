module Silpo
  class DiscountTypeParser < BaseDiscountTypeParser
    class << self
      def shop_name
        'silpo'
      end

      def common_parse_options
        {
          all_discounts_css: '.ots .photo',
          name_css: '.img h3',
          img_url_css: '.img .pirobox'
        }
      end

      def parse_discounts
        pages_count = discount_type_page.css('.ots .page div').count
        1.upto(pages_count) do |i|
          parse_page("#{discount_type.url}/?PAGEN_1=#{i}")
        end
      end
    end
  end
end
