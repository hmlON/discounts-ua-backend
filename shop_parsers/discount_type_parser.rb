class DiscountTypeParser
  class << self
    private

    # Should return name of the shop by which it can be found
    def shop_name
      raise NotImplementedError, 'Abstract method is not defined!'
    end

    # Should return name of discount type by which it can be found
    def discount_type_name
      raise NotImplementedError, 'Abstract method is not defined!'
    end

    # Should return range from start date to end date of current period
    # which is being parsed
    def parse_dates(_page)
      raise NotImplementedError, 'Abstract method is not defined!'
    end

    # Should return a hash with parse options which are the same in all of
    # shops discount types
    # These options are:
    # - all_discounts_css
    # - name_css
    # - img_url_css
    # - price_new_css
    # - price_old_css
    def common_parse_options
      raise NotImplementedError, 'Abstract method is not defined!'
    end

    # If page is parsed not only with common_parse_options it should return
    # hash of missing options
    def parse_options; end

    def shop
      Shop.find_by(name: shop_name)
    end

    def discount_type
      shop.discount_types.find_by(name: discount_type_name)
    end

    def discount_type_page
      Nokogiri::HTML(open(discount_type.url))
    end

    def active_period
      return discount_type.active_period if discount_type.active_period

      dates = parse_dates(discount_type_page)
      discount_type.periods.find_or_create_by(start_date: dates.min, end_date: dates.max)
    end

    def discount_element_parser
      shop_name.camelize.constantize::DiscountElementParser
    end

    def parse_page(url)
      options = common_parse_options.merge(parse_options)
      page = Nokogiri::HTML(open(url))
      page.css(options[:all_discounts_css]).each do |discount_element|
        discount_element_parser.new(discount_element,
                                    parse_options: options,
                                    discount_period: active_period).parse_and_create
      end
    end
  end
end
