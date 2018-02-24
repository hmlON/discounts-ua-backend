class AddPeriodicToDiscountType < ActiveRecord::Migration[5.1]
  def change
    add_column :discount_types, :periodic, :bool, default: false
  end
end
