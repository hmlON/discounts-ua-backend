# TODO: move this out of here
require 'open-uri'

# TODO: make changes to be able to delete this file
module Silpo
  def self.price_of_the_week
    PriceOfTheWeekParser.parse_discounts
  end

  def self.hot_proposal
    HotProposalParser.parse_discounts
  end
end
