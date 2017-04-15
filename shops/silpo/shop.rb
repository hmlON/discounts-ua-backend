require 'open-uri'

module Silpo
  def self.price_of_the_week
    PriceOfTheWeek.parse_discounts
  end

  def self.hot_proposal
    HotProposal.parse_discounts
  end

  DEFAULT_OPTIONS = {
    all_discounts_css: '.ots .photo',
    name_css: '.img h3',
    img_url_css: '.img .pirobox',
    price_new_css: { hrn: '.price_2014_new .hrn',
                     kop: '.price_2014_new .kop' },
    price_old_css: { hrn: '.price_2014_old .hrn',
                     kop: '.price_2014_old .kop' }
  }
end
