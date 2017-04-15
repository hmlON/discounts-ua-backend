require 'open-uri'

module Silpo
  def self.price_of_the_week
    PriceOfTheWeek.parse_discounts
  end

  def self.hot_proposal
    HotProposal.parse_discounts
  end
end
