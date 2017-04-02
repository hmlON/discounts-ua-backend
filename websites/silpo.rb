require 'nokogiri'
require 'open-uri'

class Silpo
  attr_reader :discounts

  def initialize
    @discounts = price_of_the_week + hot_proposal
  end

  def price_of_the_week
    page = Nokogiri::HTML(open(BASE_DISCOUNTS_URL + 'priceoftheweek'))
    dates = page.css('.ots').children[3].children[3].children[0].text
                .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
                .map { |date| Date.parse(date) }

    options = {
      start_date: dates.min,
      end_date: dates.max,
      discount_type: 'price_of_the_week'
    }
    parse_discount_type('priceoftheweek', options)
  end

  def hot_proposal
    page = Nokogiri::HTML(open(BASE_DISCOUNTS_URL + 'hotproposal'))
    dates = page.css('.ots').children[1].children[1].text
                .scan(/\d{1,2}\.\d{1,2}\.\d{4}/)
                .map { |date| Date.parse(date) }

    options = {
      price_new_css: { hrn: '.price-hot-new .hrn',
                       kop: '.price-hot-new .kop' },
      price_old_css: { hrn: '.price-hot-old .hrn',
                       kop: '.price-hot-old .kop' },
      start_date: dates.min,
      end_date: dates.max,
      discount_type: 'hot_proposal'
    }
    parse_discount_type('hotproposal', options)
  end

  private

  BASE_DISCOUNTS_URL = 'http://silpo.ua/ru/actions/'
  BASE_URL = 'http://silpo.ua/'
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

  def parse_discount_type(url, options = {})
    discounts = []
    page = Nokogiri::HTML(open(BASE_DISCOUNTS_URL + url))

    pages_count = page.css('.ots .page div').count
    1.upto(pages_count) do |i|
      discounts += parse_page("#{BASE_DISCOUNTS_URL + url}/?PAGEN_1=#{i}", options)
    end

    discounts
  end

  def parse_page(url, options = {})
    options = DEFAULT_OPTIONS.merge(options)
    page_discounts = []
    page = Nokogiri::HTML(open(url))
    page.css(options[:all_discounts_css]).each do |discount|
      Discount.find_or_create_by(
        name: discount.css(options[:name_css]).first.text,
        img_url: BASE_URL + discount.css(options[:img_url_css]).first.attributes['href'].value,
        price_new: discount.css(options[:price_new_css][:hrn]).first.text + '.' +
                   discount.css(options[:price_new_css][:kop]).first.text,
        price_old: discount.css(options[:price_old_css][:hrn]).first.text + '.' +
                   discount.css(options[:price_old_css][:kop]).first.text,
        shop_name: SHOP_NAME,
        discount_type: options[:discount_type],
        start_date: options[:start_date],
        end_date: options[:end_date]
      )
    end
    # p page_discounts
    page_discounts
  end
end
