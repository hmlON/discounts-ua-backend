require './lib/discounts_page'
require './lib/discount_parser'

class DiscountTypeParser
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def call
    discounts = page.discounts
    discounts += parse_next_pages if pagination?
    discounts
  end

  private

  def page
    @page ||= DiscountsPage.new(
      discounts_url: config[:url],
      discounts_xpath: config[:discounts_xpath],
      discount_parser: discount_parser,
      pagination: config[:pagination]
    )
  end

  def discount_parser
    DiscountParser.new(config[:discount])
  end

  def parse_next_pages
    pages_count = page.total_pages_count
    current_page = page
    discounts = []

    2.upto(pages_count) do
      current_page = current_page.next
      discounts += current_page.discounts
    end

    discounts
  end

  def pagination?
    config[:pagination]
  end
end
