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
        page = Nokogiri::HTML(open(discount_type.url))
        dates = parse_dates(page)

        active_discount_type = discount_type.periods.find_or_create_by(start_date: dates.min, end_date: dates.max)
        parse_discount_type(active_discount_type)
      end

      private

      # Should return name of discount type by which it can be found
      def discount_type_name
        raise NotImplementedError, 'Abstract method is not defined!'
      end

      # Should return range from start date to end date of current period
      # which is being parsed
      def parse_dates(page)
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

      def parse_discount_type(active_period)
        url = active_period.discount_type.url
        page = Nokogiri::HTML(open(url))

        pages_count = page.css('.ots .page div').count
        1.upto(pages_count) do |i|
          parse_page("#{url}/?PAGEN_1=#{i}", active_period)
        end
      end

      def parse_page(url, active_period)
        options = COMMON_PARSE_OPTIONS.merge(parse_options)
        page = Nokogiri::HTML(open(url))
        page.css(options[:all_discounts_css]).each do |discount_element|
          active_period.discounts.create(
            name: parse_discount_text(discount_element, options),
            img_url: parse_discount_img_url(discount_element, options),
            price_new: parse_discount_price_new(discount_element, options),
            price_old: parse_discount_price_old(discount_element, options)
          )
        end
      end

      # Move to DiscountElementParser class
      def parse_discount_text(discount_element, options)
        discount_element.css(options[:name_css]).first.text
      end

      def parse_discount_img_url(discount_element, options)
        shop.url + discount_element.css(options[:img_url_css]).first.attributes['href'].value
      end

      def parse_discount_price_new(discount_element, options)
        discount_element.css(options[:price_new_css][:hrn]).first.text + '.' + \
          discount_element.css(options[:price_new_css][:kop]).first.text
      end

      def parse_discount_price_old(discount_element, options)
        discount_element.css(options[:price_old_css][:hrn]).first.text + '.' + \
          discount_element.css(options[:price_old_css][:kop]).first.text
      end
      # end: Move to DiscountElementParser class
    end
  end
end
