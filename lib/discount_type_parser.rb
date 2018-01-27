require './lib/discounts_page'
require './lib/discount_parser'

class DiscountTypeParser
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def call
    page = DiscountsPage.new(discount_type_url: config[:url],
                             current_page_number: config.dig(:pagination, :starts_at),
                             discount_parser: DiscountParser.new(config[:discount]),
                             **config)
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

  private

  def parse_page(page)
    discounts = page
  end

  def pagination?
    config[:pagination]
  end
end
