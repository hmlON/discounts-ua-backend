require 'nokogiri'
require 'open-uri'

class Silpo
  def discounts
    price_of_the_week
  end

  def price_of_the_week
    page = Nokogiri::HTML(open(base_uri + '/ru/actions/priceoftheweek'))
    discounts = []
    pages_count = page.css('.ots .page div').count
    1.upto(pages_count) do |i|
      page = Nokogiri::HTML(open(base_uri + "/ru/actions/priceoftheweek/?PAGEN_1=#{i}"))
      page.css('.ots .photo').each do |discount|
        discounts << { name: discount.css('.img h3').first.text,
                       img_url: base_uri + discount.css('.img .pirobox').first.attributes['href'].value,
                       price_new: discount.css('.price_2014_new .hrn').first.text + '.' +
                                  discount.css('.price_2014_new .kop').first.text,
                       price_old: discount.css('.price_2014_old .hrn').first.text + '.' +
                                  discount.css('.price_2014_old .kop').first.text }
      end
    end
    discounts
  end

  private

  def base_uri
    'http://silpo.ua'
  end
end
