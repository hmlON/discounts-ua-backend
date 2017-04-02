class ChangeDiscountTypeToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :discounts, :price_new, :float, null: false
    change_column :discounts, :price_old, :float, null: false
  end
end
