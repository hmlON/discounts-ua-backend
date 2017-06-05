module ATB
  class DiscountElementParser < BaseDiscountElementParser
    private

    def parse_text
      discount_element.css('.promo_info_text').text.split.join(' ')
    end

    def parse_img_url
      discount_period.discount_type.shop.url + \
        discount_element.css('.promo_image_link').first.children[1].attributes['data-src'].value
    end

    def parse_small_img_url
      parse_img_url
    end

    def parse_price_new
      discount_element.css('.promo_price').children[0].text + '.' + \
        discount_element.css('.promo_price').children[1].text
    end

    def parse_price_old
      old_price = discount_element.css('.promo_old_price').text
      return parse_price_new if old_price.empty?
      old_price
    end
  end
end
