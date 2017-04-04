class AddUrlToShopAndDiscountType < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :base_url, :string
    add_column :discount_types, :url, :string
  end
end
