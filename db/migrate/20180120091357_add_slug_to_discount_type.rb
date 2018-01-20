class AddSlugToDiscountType < ActiveRecord::Migration[5.1]
  def change
    add_column :discount_types, :slug, :string
  end
end
