module Silpo
  class DiscountTypeParser
    SHOP_NAME = 'silpo'

    DEFAULT_OPTIONS = {
      all_discounts_css: '.ots .photo',
      name_css: '.img h3',
      img_url_css: '.img .pirobox',
      price_new_css: { hrn: '.price_2014_new .hrn',
                       kop: '.price_2014_new .kop' },
      price_old_css: { hrn: '.price_2014_old .hrn',
                       kop: '.price_2014_old .kop' }
    }

    def self.shop
      Shop.find_by(name: SHOP_NAME)
    end

    def self.parse_discount_type(active_period, options = {})
      url = shop.base_url + active_period.discount_type.url
      page = Nokogiri::HTML(open(url))

      pages_count = page.css('.ots .page div').count
      1.upto(pages_count) do |i|
        parse_page("#{url}/?PAGEN_1=#{i}", active_period, options)
      end
    end

    def self.parse_page(url, active_period, options = {})
      options = DEFAULT_OPTIONS.merge(options)
      page = Nokogiri::HTML(open(url))
      page.css(options[:all_discounts_css]).each do |discount|
        active_period.discounts.create(
          name: discount.css(options[:name_css]).first.text,
          img_url: shop.base_url + discount.css(options[:img_url_css]).first.attributes['href'].value,
          price_new: discount.css(options[:price_new_css][:hrn]).first.text + '.' +
                     discount.css(options[:price_new_css][:kop]).first.text,
          price_old: discount.css(options[:price_old_css][:hrn]).first.text + '.' +
                     discount.css(options[:price_old_css][:kop]).first.text,
        )
      end
    end
  end
end
