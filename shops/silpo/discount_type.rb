module Silpo
  class DiscountTypeParser
    class << self
      SHOP_NAME = 'silpo'

      private

      def shop
        Shop.find_by(name: SHOP_NAME)
      end

      def parse_discount_type(active_period, options = {})
        url = shop.base_url + active_period.discount_type.url
        page = Nokogiri::HTML(open(url))

        pages_count = page.css('.ots .page div').count
        1.upto(pages_count) do |i|
          parse_page("#{url}/?PAGEN_1=#{i}", active_period, options)
        end
      end

      def parse_page(url, active_period, options = {})
        options = default_options.merge(options)
        page = Nokogiri::HTML(open(url))
        page.css(options[:all_discounts_css]).each do |discount|
          active_period.discounts.create(
            name: discount.css(options[:name_css]).first.text,
            img_url: shop.base_url + discount.css(options[:img_url_css]).first.attributes['href'].value,
            price_new: discount.css(options[:price_new_css][:hrn]).first.text + '.' +
                       discount.css(options[:price_new_css][:kop]).first.text,
            price_old: discount.css(options[:price_old_css][:hrn]).first.text + '.' +
                       discount.css(options[:price_old_css][:kop]).first.text,
          )
        end
      end

      def parse_discount_text(discount_page_element, options)
        discount_page_element.css(options[:name_css]).first.text
      end
    end
  end
end
