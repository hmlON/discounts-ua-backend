class DiscountTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :periodic, :start_date, :end_date, :discounts
end
