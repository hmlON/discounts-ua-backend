require 'open-uri'
require 'capybara/poltergeist'
require './lib/discounts_page'
require './lib/discount_parser'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    js_errors: false,
    phantomjs_options: ['--load-images=no']
  )
end

Capybara.default_driver = :poltergeist
Capybara.default_selector = :xpath

CONFIG = {
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
      pagination: {
        parameter: 'offset',
        starts_at: 0,
        step: 6,
        pages_count_xpath: "//a[contains(@class, 'pagination-link')][3]"
      }
    }
  ]
}

class DiscountTypeParser
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def call
    discounts = []

    page = DiscountsPage.new(shop_url: config[:url],
                             discounts_path: discount_type_data[:path],
                             current_page_number: discount_type_data.dig(:pagination, :starts_at),
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
     DiscountsPage.new(shop_url: config[:url],
                             discounts_path: discount_type_data[:path],
                             current_page_number: discount_type_data[:pagination][:starts_at],
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
    config[:discount_types].first
  end
end
