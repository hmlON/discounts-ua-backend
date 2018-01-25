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
    discount_element.find('.' + rules[:name_xpath]).text
  end

  def old_price
    parse_price(:old)
  end

  def new_price
    parse_price(:new)
  end

  def image
    discount_element.find('.' + rules[:image_xpath])[:src]
  end

  private

  def parse_price(type)
    price_is_divided = rules[:"#{type}_price_divided"]
    price = if price_is_divided
              integer = discount_element.find('.' + rules[:"#{type}_price_integer_xpath"]).text
              fraction = discount_element.find('.' + rules[:"#{type}_price_fraction_xpath"]).text
              "#{integer}.#{fraction}"
            else
              discount_element.find('.' + rules[:"#{type}_price_xpath"]).text
            end
    price.to_f
  end
end
