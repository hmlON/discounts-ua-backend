class DiscountParser
  attr_reader :discount_element, :rules

  def initialize(discount_element, rules)
    @discount_element = discount_element
    @rules = rules
  end

  def call
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

  def new_price
    if rules[:new_price_divided]
      integer = discount_element.find('.' + rules[:new_price_integer_xpath]).text
      fraction = discount_element.find('.' + rules[:new_price_fraction_xpath]).text
      "#{integer}.#{fraction}"
    end
  end

  def old_price
    discount_element.find('.' + rules[:old_price_xpath]).text
  end

  def image
    discount_element.find('.' + rules[:image_xpath])[:src]
  end
end
