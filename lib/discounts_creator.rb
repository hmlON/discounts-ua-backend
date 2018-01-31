class DiscountsCreator
  attr_reader :discount_type, :discount_type_parser, :period

  def initialize(discount_type:, discount_type_parser:, period:)
    @discount_type = discount_type
    @discount_type_parser = discount_type_parser
    @period = period
  end

  def call
    discounts_data = discount_type_parser.call
    discounts_data.map { |discount_data| find_or_create_discount(discount_data) }
  end

  def find_or_create_discount(discount_data)
    discount = current_period.discounts.find_or_initialize_by(name: discount_data[:name])
    discount.img_url = discount_data[:image]
    discount.price_old = discount_data[:old_price]
    discount.price_new = discount_data[:new_price]
    discount.save!
    discount
  end

  def current_period
    @current_period ||= discount_type.periods.find_or_create_by(
      start_date: current_period_date_range.first,
      end_date: current_period_date_range.last
    )
  end

  def current_period_date_range
    today = Date.today
    global_starts_at = Date.parse(period[:starts_at])
    starts_at = today - ((today-global_starts_at).to_i % period[:duration_in_days]).days
    ends_at = starts_at + period[:duration_in_days].days
    starts_at..ends_at
  end
end
