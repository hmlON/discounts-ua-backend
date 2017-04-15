require 'nokogiri'
require 'open-uri'

class Silpo
  def price_of_the_week
    discount_type = shop.discount_types.find_or_create_by(name: 'price_of_the_week', url: '/ru/actions/priceoftheweek')

    page = Nokogiri::HTML(open(shop.base_url + discount_type.url))
    dates = page.css('.ots').children[3].children[3].children[0].text
                .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
                .map { |date| Date.parse(date) }

    active_discount_type = discount_type.periods.create(start_date: dates.min, end_date: dates.max)
    parse_discount_type(active_discount_type)
  end

  def hot_proposal
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

  private

  DEFAULT_OPTIONS = {
    all_discounts_css: '.ots .photo',
    name_css: '.img h3',
    img_url_css: '.img .pirobox',
    price_new_css: { hrn: '.price_2014_new .hrn',
                     kop: '.price_2014_new .kop' },
    price_old_css: { hrn: '.price_2014_old .hrn',
                     kop: '.price_2014_old .kop' }
  }

  def shop
    Shop.find_by(name: 'silpo')
  end

  def parse_discount_type(active_period, options = {})
    url = shop.base_url + active_period.discount_type.url
    page = Nokogiri::HTML(open(url))

    pages_count = page.css('.ots .page div').count
    1.upto(pages_count) do |i|
      parse_page("#{url}/?PAGEN_1=#{i}", active_period, options)
    end
  end

  def parse_page(url, active_period, options = {})
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
