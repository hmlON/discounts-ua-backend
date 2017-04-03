class RemoveUnusedAttributesFromDiscounts < ActiveRecord::Migration[5.0]
  def change
    add_reference :discounts, :discount_type_period, index: true, null: false
    add_foreign_key :discounts, :discount_type_periods
    remove_column :discounts, :start_date, :datetime
    remove_column :discounts, :end_date, :datetime
    remove_column :discounts, :shop_name, :string
    remove_column :discounts, :discount_type, :string
  end
end
