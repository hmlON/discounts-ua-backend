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

class DiscountTypeParser
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def call
    page = DiscountsPage.new(discount_type_url: config[:url] + discount_type_data[:path],
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
