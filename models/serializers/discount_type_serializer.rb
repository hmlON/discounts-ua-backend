class DiscountTypeSerializer < ActiveModel::Serializer
  attributes :active_period

  def active_period
    DiscountTypePeriodSerializer.new(object.active_period, root: false)
  end
end
