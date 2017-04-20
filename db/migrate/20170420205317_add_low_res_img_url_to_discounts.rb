class AddLowResImgUrlToDiscounts < ActiveRecord::Migration[5.0]
  def change
    add_column :discounts, :small_img_url, :string
  end
end
