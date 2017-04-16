module Silpo
  class DiscountElementParser < ::DiscountElementParser
    private

    def parse_discount_text
      discount_element.css(parse_options[:name_css]).first.text
    end

    def parse_discount_img_url
      discount_period.discount_type.shop.url + \
        discount_element.css(parse_options[:img_url_css]).first.attributes['href'].value
    end

    def parse_discount_price_new
      discount_element.css(parse_options[:price_new_css][:hrn]).first.text + '.' + \
        discount_element.css(parse_options[:price_new_css][:kop]).first.text
    end

    def parse_discount_price_old
      discount_element.css(parse_options[:price_old_css][:hrn]).first.text + '.' + \
        discount_element.css(parse_options[:price_old_css][:kop]).first.text
    end
  end
end
