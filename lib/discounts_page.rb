class DiscountsPage
  attr_reader :shop_url, :discounts_path, :pagination, :pagination_options

  def initialize(shop_url:, discounts_path:, current_page_number: nil, **options)
    @shop_url, @discounts_path = shop_url, discounts_path
    @pagination = options[:pagination]
    if pagination?
      @pagination_options = options[:pagination]
      @pagination_options[:current_page_number] = current_page_number || 1
      @pagination_options[:step] ||= 1
    end
  end

  def url
    url = shop_url + discounts_path

    if pagination?
      parameter = pagination_options[:parameter]
      page_number = pagination_options[:current_page_number] * pagination_options[:step]
      url = "#{url}?#{parameter}=#{page_number}"
    end

    url
  end

  def to_html
    @to_html = begin
      browser = Capybara.current_session
      browser.visit url
      wait_for_loading
      browser
    end
  end

  def pagination?
    @pagination
  end

  def next
    return unless pagination?

    self.class.new(
      shop_url: shop_url,
      discounts_path: discounts_path,
      pagination: pagination_options,
      current_page_number: pagination_options[:current_page_number] + 1
    )
  end

  def total_pages_count
    to_html.find(pagination_options[:pages_count_xpath]).text.to_i
  end

  private

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
