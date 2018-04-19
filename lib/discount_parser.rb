# Parses discount by rules specified in config
class DiscountParser
  attr_reader :discount_element, :rules

  def initialize(rules)
    @rules = rules
  end

  def call(discount_element)
    @discount_element = discount_element

    {
      name: name,
      old_price: old_price,
      new_price: new_price,
      image: image
    }
  end

  def name
    return unless rules[:name_xpath]

    discount_element.find('.' + rules[:name_xpath]).text
                    .gsub(/\s+/, ' ')
                    .strip
  end

  def old_price
    parse_price(:old)
  end

  def new_price
    parse_price(:new)
  end

  def image
    return unless rules[:image_xpath]

    @image = discount_element.find('.' + rules[:image_xpath])[:src]
    @image = rules[:image_base_url] + @image if rules[:image_relative_url]
    @image
  end

  private

  def parse_price(type)
    return unless rules[:"#{type}_price_xpath"] || rules[:"#{type}_price_divided"]

    price_is_divided = rules[:"#{type}_price_divided"]
    price = price_is_divided ? parse_divided_price(type) : parse_regular_price(type)
    price.to_f
  end

  def parse_divided_price(type)
    integer = discount_element.find('.' + rules[:"#{type}_price_integer_xpath"]).text
    fraction = discount_element.find('.' + rules[:"#{type}_price_fraction_xpath"]).text
    "#{integer}.#{fraction}"
  end

  def parse_regular_price(type)
    discount_element.find('.' + rules[:"#{type}_price_xpath"]).text
  end
end
