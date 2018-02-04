class ShopSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug

  has_many :discount_types
end
