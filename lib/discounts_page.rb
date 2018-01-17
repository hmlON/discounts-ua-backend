class DiscountsPage
  attr_reader :shop_url, :discounts_path, :discounts_xpath, :discount_parser, :options, :pagination, :pagination

  def initialize(shop_url:, discounts_path:, current_page_number: nil, discount_parser:, **options)
    @shop_url = shop_url
    @discounts_path =  discounts_path
    @discount_parser = discount_parser
    @options = options
    @discounts_xpath = options[:discounts_xpath]

    @pagination = options[:pagination]
    if pagination?
      @pagination[:current_page_number] = current_page_number || 1
      @pagination[:step] ||= 1
    end
  end

  def url
    url = shop_url + discounts_path

    if pagination?
      parameter = pagination[:parameter]
      page_number = pagination[:current_page_number] * pagination[:step]
      url = "#{url}?#{parameter}=#{page_number}"
    end

    url
  end

  def discounts
    to_html
      .all(discounts_xpath)
      .map { |discount_element| discount_parser.call(discount_element) }
  end

  def pagination?
    @pagination
  end

  def next
    return unless pagination?

    self.class.new(
      shop_url: shop_url,
      discounts_path: discounts_path,
      discount_parser: discount_parser,
      current_page_number: pagination[:current_page_number] + 1,
      **options
    )
  end

  def total_pages_count
    to_html.find(pagination[:pages_count_xpath]).text.to_i
  end

  private

  def to_html
    @to_html ||= begin
      browser = Capybara.current_session
      browser.visit url
      wait_for_loading
      browser
    end
  end

  # def wait_until
  #   require "timeout"
  #   Timeout.timeout(Capybara.default_max_wait_time) do
  #     sleep(0.1) until value = yield
  #     value
  #   end
  # end

  def wait_for_loading
    sleep 5
  end
end
