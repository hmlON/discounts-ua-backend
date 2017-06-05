require_relative './discount_type_parser'

module ATB
  class EconomyParser < DiscountTypeParser
    class << self
      private

      def discount_type_name
        'economy'
      end

      # TODO: change to use ranges
      def parse_dates(_page)
        start_date = Date.today.beginning_of_week(:wednesday)
        end_date = start_date + 6.days
        [start_date, end_date]
      end
    end
  end
end
