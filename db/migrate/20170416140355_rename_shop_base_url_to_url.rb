class RenameShopBaseUrlToUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :shops, :base_url, :url
    rename_column :discount_types, :url, :path
  end
end
