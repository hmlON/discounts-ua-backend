class ShopSerializer < ActiveModel::Serializer
  attributes :name

  has_many :discount_types
end
