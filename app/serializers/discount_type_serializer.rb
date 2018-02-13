class DiscountTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :end_date, :discounts
end
