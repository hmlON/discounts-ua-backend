# TODO: create ability to change this to custom
class DiscountElementParser
  attr_reader :discount_element, :parse_options, :discount_period

  def initialize(discount_element, parse_options:, discount_period:)
    @discount_element = discount_element
    @parse_options = parse_options
    @discount_period = discount_period
  end

  def parse_and_create
    discount_period.discounts.create(
      name: parse_discount_text,
      img_url: parse_discount_img_url,
      price_new: parse_discount_price_new,
      price_old: parse_discount_price_old
    )
  end

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
