require 'open-uri'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    js_errors: false,
    phantomjs_options: ['--load-images=no']
  )
end

Capybara.default_driver = :poltergeist
Capybara.default_selector = :xpath

class DiscountTypeParser
  DATA = {
    name: 'silpo',
    url: 'https://silpo.ua',
    discount_types: [
      {
        name: 'price_of_the_week',
        path: '/offers/akciyi-vlasnogo-importu',
        discounts_xpath: "//ul[contains(@class, 'product-list product-list__per-row-3')]/li[contains(@class, 'normal')]/a[contains(@class, 'product-list__item normal size-normal')]",
        discount: {
          name_xpath: "//div[contains(@class, 'product-list__item-description')]",
          image_xpath: "//div[contains(@class, 'product-list__item-image')]/img",
          new_price_divided: true,
          new_price_integer_xpath: "//div[contains(@class, 'product-price__integer')]",
          new_price_fraction_xpath: "//div[contains(@class, 'product-price__fraction')]",
          old_price_xpath: "//div[contains(@class, 'product-price__other')]/div[contains(@class, 'product-price__old')]",
        },
        pagination: true,
        pagination_parameter: 'offset',
        pagination_starts_at: 0,
        pagination_step: 6,
        pages_count_xpath: "//a[contains(@class, 'pagination-link')][3]"
      }
    ]
  }

  def call
    discounts = []

    page = DiscountsPage.new(shop_url: DATA[:url],
                             discounts_path: discount_type_data[:path],
                             current_page_number: discount_type_data[:pagination_starts_at],
                             **discount_type_data)
    discounts += parse_page(page)

    if pagination?
      pages_count = page.total_pages_count
      2.upto(pages_count) do
        page = page.next
        discounts += parse_page(page)
      end
    end

    discounts
  end

  def page
     DiscountsPage.new(shop_url: DATA[:url],
                             discounts_path: discount_type_data[:path],
                             current_page_number: discount_type_data[:pagination_starts_at],
                             **discount_type_data)
  end

  def parse_page(page)
    discounts = page.to_html.all(discount_type_data[:discounts_xpath])
    discounts.map { |discount| parse_discount(discount) }
  end

  def pagination?
    discount_type_data[:pagination]
  end

  def parse_discount(discount)
    DiscountParser.new(discount, discount_type_data[:discount]).call
  end

  def discount_type_data
    DATA[:discount_types].find { |dt| dt[:name] == 'price_of_the_week' }
  end
end

class DiscountParser
  attr_reader :discount_element, :data

  def initialize(discount_element, data)
    @discount_element = discount_element
    @data = data
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
    discount_element.find('.' + data[:name_xpath]).text
  end

  def new_price
    if data[:new_price_divided]
      integer = discount_element.find('.' + data[:new_price_integer_xpath]).text
      fraction = discount_element.find('.' + data[:new_price_fraction_xpath]).text
      "#{integer}.#{fraction}"
    end
  end

  def old_price
    discount_element.find('.' + data[:old_price_xpath]).text
  end

  def image
    discount_element.find('.' + data[:image_xpath])[:src]
  end
end

class DiscountsPage
  attr_reader :shop_url, :discounts_path, :pagination, :pagination_options

  def initialize(shop_url:, discounts_path:, current_page_number: nil, **options)
    @shop_url, @discounts_path = shop_url, discounts_path
    @pagination = options[:pagination]
    if pagination?
      @pagination_options = {
        pagination_parameter: options[:pagination_parameter],
        current_page_number: current_page_number || 1,
        pagination_step: options[:pagination_step] || 1,
        pages_count_xpath: options[:pages_count_xpath],
      }
    end
  end

  def url
    url = shop_url + discounts_path

    if pagination?
      parameter = pagination_options[:pagination_parameter]
      page_number = pagination_options[:current_page_number] * pagination_options[:pagination_step]
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
      **pagination_options,
      shop_url: shop_url,
      discounts_path: discounts_path,
      pagination: true,
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
