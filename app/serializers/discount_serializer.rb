class DiscountSerializer < ActiveModel::Serializer
  attributes :id, :name, :img_url, :small_img_url, :price_new, :price_old
end
