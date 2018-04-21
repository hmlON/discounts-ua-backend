class AddWidthToDiscounts < ActiveRecord::Migration[5.1]
  def up
    add_column :discounts, :width_on_mobile, :float

    Discount.update_all(width_on_mobile: 0.5)
  end

  def down
    remove_column :discounts, :width_on_mobile
  end
end
