require './lib/discounts_page'
require './lib/discount_parser'

# Parses discount type by rules specified in config
class DiscountTypeParser
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def call
    puts "DiscountTypeParser: started parsing #{config[:url]}"
    discounts = page.discounts
    discounts += parse_next_pages if pagination?
    puts "DiscountTypeParser: finished parsing #{config[:url]}"
    discounts
  end

  private

  def page
    @page ||= DiscountsPage.new(
      discounts_url:   config[:url],
      discounts_xpath: config[:discounts_xpath],
      discount_parser: discount_parser,
      pagination:      config[:pagination],
      js:              config[:js],
      scroll_to_load:  config[:scroll_to_load]
    )
  end

  def discount_parser
    DiscountParser.new(config[:discount])
  end

  def parse_next_pages
    discounts = []
    current_page = page

    while current_page.has_next?
      current_page = current_page.next
      discounts += current_page.discounts
    end

    discounts
  end

  def pagination?
    config[:pagination]
  end
end
