class RemoveNotNullChecksFromDiscounts < ActiveRecord::Migration[5.1]
  def change
    change_column_null :discounts, :name, true
    change_column_null :discounts, :price_new, true
    change_column_null :discounts, :price_old, true
  end
end
