class CreateDiscountTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_types do |t|
      t.string :name,                        null: false
      t.belongs_to :shop, foreign_key: true, null: false
    end
  end
end
