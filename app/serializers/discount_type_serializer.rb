class DiscountTypeSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :name,
    :periodic,
    :last_updated_at,
    :start_date,
    :end_date,
    :discounts
  )
end
