class DiscountsPage
  attr_reader :discounts_url, :discounts_xpath, :discount_parser, :pagination, :js

  def initialize(discounts_url:, discount_parser:, discounts_xpath:, pagination: nil, js: false)
    @discounts_url = discounts_url
    @discount_parser = discount_parser
    @discounts_xpath = discounts_xpath
    @pagination = pagination
    @js = js
    set_pagination_defaults if pagination?
  end

  def url
    return discounts_url unless pagination?

    parameter = pagination[:parameter]
    page_number = pagination[:current_page_number] * pagination[:step]
    "#{discounts_url}?#{parameter}=#{page_number}"
  end

  def discounts
    puts "DiscountsPage: parsing #{url}"
    to_html
      .all(discounts_xpath)
      .map { |discount_element| discount_parser.call(discount_element) }
  end

  def has_next?
    pagination[:current_page_number] < total_pages_count
  end

  def next
    next_pagination_config = pagination.merge(
      current_page_number: pagination[:current_page_number] + 1,
      pages_count: total_pages_count
    )

    self.class.new(
      discounts_url: discounts_url,
      discount_parser: discount_parser,
      discounts_xpath: discounts_xpath,
      pagination: next_pagination_config,
      js: true
    )
  end

  private

  def to_html
    @to_html ||= if js
                   browser = Capybara.current_session
                   browser.visit url
                   wait_for_loading
                   browser
                 else
                   body = Net::HTTP.get(URI(url))
                   Capybara.string(body)
    end
  end

  def pagination?
    !pagination.nil?
  end

  def set_pagination_defaults
    @pagination[:current_page_number] ||= pagination[:starts_at] || 1
    @pagination[:parameter] ||= 'page'
    @pagination[:step] ||= 1
  end

  def total_pages_count
    pagination[:pages_count] || to_html.find(pagination[:pages_count_xpath]).text.to_i
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
