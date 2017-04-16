module Silpo
  class HotProposal < DiscountTypeParser
    def self.default_options
      {
        all_discounts_css: '.ots .photo',
        name_css: '.img h3',
        img_url_css: '.img .pirobox',
        price_new_css: { hrn: '.price_2014_new .hrn',
                         kop: '.price_2014_new .kop' },
        price_old_css: { hrn: '.price_2014_old .hrn',
                         kop: '.price_2014_old .kop' }
      }
    end

    def self.parse_discounts
      discount_type = shop.discount_types.find_or_create_by(name: 'hot_proposal', url: '/ru/actions/hotproposal')

      page = Nokogiri::HTML(open(shop.base_url + discount_type.url))
      dates = page.css('.ots').children[1].children[1].text
                  .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
                  .map { |date| Date.parse(date) }

      active_discount_type = discount_type.periods.create(start_date: dates.min, end_date: dates.max)
      options = {
        price_new_css: { hrn: '.price-hot-new .hrn',
                         kop: '.price-hot-new .kop' },
        price_old_css: { hrn: '.price-hot-old .hrn',
                         kop: '.price-hot-old .kop' }
      }
      parse_discount_type(active_discount_type, options)
    end
  end
end
