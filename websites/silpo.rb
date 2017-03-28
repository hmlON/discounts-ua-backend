require 'nokogiri'
require 'open-uri'

class Silpo
  attr_reader :discounts

  def initialize
    @discounts = price_of_the_week
  end

  def price_of_the_week
    page = Nokogiri::HTML(open(BASE_URL + 'priceoftheweek'))
    discounts = []
    pages_count = page.css('.ots .page div').count
    1.upto(pages_count) do |i|
      discounts += parse_page("priceoftheweek/?PAGEN_1=#{i}")
    end
    discounts
  end

  private

  BASE_URL = 'http://silpo.ua/ru/actions/'
  BASE_IMG_URL = 'http://silpo.ua/'

  DEFAULT_OPTIONS = {
    all_discounts_css: '.ots .photo',
    name_css: '.img h3',
    img_url_css: '.img .pirobox',
    price_new_css: { hrn: '.price_2014_new .hrn',
                     kop: '.price_2014_new .kop' },
    price_old_css: { hrn: '.price_2014_old .hrn',
                     kop: '.price_2014_old .kop' }
  }

  def parse_page(url, options = {})
    options = DEFAULT_OPTIONS.merge(options)
    page_discounts = []
    page = Nokogiri::HTML(open(BASE_URL + url))
    page.css(options[:all_discounts_css]).each do |discount|
      page_discounts << { name: discount.css(options[:name_css]).first.text,
        img_url: BASE_IMG_URL + discount.css(options[:img_url_css]).first.attributes['href'].value,
        price_new: discount.css(options[:price_new_css][:hrn]).first.text + '.' +
                   discount.css(options[:price_new_css][:kop]).first.text,
        price_old: discount.css(options[:price_old_css][:hrn]).first.text + '.' +
                   discount.css(options[:price_old_css][:kop]).first.text }
    end
    page_discounts
  end
end
