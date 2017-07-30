class DiscountTypePeriodSerializer < ActiveModel::Serializer
  attributes :start_date, :end_date
  has_many :discounts
end
