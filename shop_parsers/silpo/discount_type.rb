module Silpo
  class DiscountTypeParser
    class << self
      SHOP_NAME = 'silpo'

      COMMON_PARSE_OPTIONS = {
        all_discounts_css: '.ots .photo',
        name_css: '.img h3',
        img_url_css: '.img .pirobox'
      }

      def parse_discounts
        pages_count = discount_type_page.css('.ots .page div').count
        1.upto(pages_count) do |i|
          parse_page("#{discount_type.url}/?PAGEN_1=#{i}")
        end
      end

      private

      # Should return name of discount type by which it can be found
      def discount_type_name
        raise NotImplementedError, 'Abstract method is not defined!'
      end

      # Should return range from start date to end date of current period
      # which is being parsed
      def parse_dates(_page)
        raise NotImplementedError, 'Abstract method is not defined!'
      end

      # If page is parsed not only with COMMON_PARSE_OPTIONS it should return
      # hash of missing options
      def parse_options; end

      def shop
        Shop.find_by(name: SHOP_NAME)
      end

      def discount_type
        shop.discount_types.find_by(name: discount_type_name)
      end

      def discount_type_page
        Nokogiri::HTML(open(discount_type.url))
      end

      def active_period
        return discount_type.active_period if discount_type.active_period

        dates = parse_dates(discount_type_page)
        discount_type.periods.find_or_create_by(start_date: dates.min, end_date: dates.max)
      end

      def parse_page(url)
        options = COMMON_PARSE_OPTIONS.merge(parse_options)
        page = Nokogiri::HTML(open(url))
        page.css(options[:all_discounts_css]).each do |discount_element|
          DiscountElementParser.new(discount_element,
                                    parse_options: options,
                                    discount_period: active_period).parse_and_create
        end
      end
    end
  end
end
