# Parses discounts page by rules specified in config
class DiscountsPage
  attr_reader :discounts_url, :discounts_xpath, :discount_parser, :pagination, :js, :scroll_to_load

  def initialize(discounts_url:, discount_parser:, discounts_xpath:, pagination: nil, js: false, scroll_to_load: false)
    @discounts_url = discounts_url
    @discount_parser = discount_parser
    @discounts_xpath = discounts_xpath
    @pagination = pagination
    @js = js
    @scroll_to_load = scroll_to_load
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
    @to_html ||= js ? browser_page : plain_html_page
  end

  def browser_page
    browser = Capybara.current_session
    browser.visit url
    wait_for_loading

    scroll_page(browser) if scroll_to_load?

    browser
  end

  def plain_html_page
    body = Net::HTTP.get(URI(url))
    Capybara.string(body)
  end

  def pagination?
    !!pagination
  end

  def set_pagination_defaults
    @pagination[:current_page_number] ||= pagination[:starts_at] || 1
    @pagination[:parameter] ||= 'page'
    @pagination[:step] ||= 1
  end

  def total_pages_count
    pagination[:pages_count] || to_html.find(pagination[:pages_count_xpath]).text.to_i
  end

  def scroll_to_load?
    !!scroll_to_load
  end

  def scroll_page(browser)
    first_discount = browser.all(discounts_xpath).first
    discounts_on_page_counts = []
    new_discounts_are_being_loaded = true
    min_down_presses = stop_down_presses = 20

    while new_discounts_are_being_loaded do
      first_discount.send_keys(:page_down)
      sleep(0.01)

      discounts_on_page_counts << browser.all(discounts_xpath).count

      not_pressed_down_enough = discounts_on_page_counts.count <= min_down_presses
      new_discounts_were_loaded = discounts_on_page_counts.last(stop_down_presses).uniq.count > 1
      new_discounts_are_being_loaded = not_pressed_down_enough || new_discounts_were_loaded
    end
  end

  # def wait_for_loading
  #   require "timeout"
  #   Timeout.timeout(Capybara.default_max_wait_time) do
  #     sleep(0.1) until value = yield
  #     value
  #   end
  # end

  def wait_for_loading
    sleep 1
  end
end
