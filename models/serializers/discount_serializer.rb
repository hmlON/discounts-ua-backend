class DiscountSerializer < ActiveModel::Serializer
  attributes :name, :img_url, :small_img_url, :price_new, :price_old
end
