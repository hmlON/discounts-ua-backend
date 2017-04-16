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

  private

  # Should return text of currently parsed discount
  def parse_discount_text
    raise NotImplementedError, 'Abstract method is not defined!'
  end

  # Should return url to image of currently parsed discount
  def parse_discount_img_url
    raise NotImplementedError, 'Abstract method is not defined!'
  end

  # Should return new price of currently parsed discount
  def parse_discount_price_new
    raise NotImplementedError, 'Abstract method is not defined!'
  end

  # Should return old price of currently parsed discount
  def parse_discount_price_old
    raise NotImplementedError, 'Abstract method is not defined!'
  end
end
