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
    page = DiscountsPage.new(shop_url: config[:url],
                             discounts_path: discount_type_data[:path],
                             current_page_number: discount_type_data.dig(:pagination, :starts_at),
                             discount_parser: DiscountParser.new(discount_type_data[:discount]),
                             **discount_type_data)
    discounts = page.discounts

    if pagination?
      pages_count = page.total_pages_count
      2.upto(pages_count) do
        page = page.next
        discounts += page.discounts
      end
    end

    discounts
  end

  def parse_page(page)
    discounts = page
  end

  def pagination?
    discount_type_data[:pagination]
  end

  def discount_type_data
    config[:discount_types].first
  end
end
