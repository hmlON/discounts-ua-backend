class DiscountsCreator
  attr_reader :discount_type, :discount_type_parser, :period

  def initialize(discount_type:, discount_type_parser:, period:)
    @discount_type = discount_type
    @discount_type_parser = discount_type_parser
    @period = period
  end

  def call
    p current_period
    # p discount_type
    # discount_type_parser.class
  end

  def current_period
    today = Date.today
    global_starts_at = Date.parse(period[:starts_at])
    starts_at = today - ((today-global_starts_at).to_i % period[:duration_in_days]).days
    ends_at = starts_at + period[:duration_in_days].days
    starts_at..ends_at
  end
end
